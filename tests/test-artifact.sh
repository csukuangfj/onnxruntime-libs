#!/usr/bin/env bash
# Everything that must hold for a built onnxruntime artifact, in one place.
# Runs *inside* the target distro -- the workflow is what puts it in the matching
# manylinux container; this script just runs.
#
#   1. report  size, dynamic deps, glibc/GLIBCXX versions
#   2. ABI     the C++ std::string ABI the name claims
#   3. dlopen  it is actually usable here
#   4. smoke   call the C API end to end
#
# No arguments: it uses the single onnxruntime-linux-* directory in the current
# directory, which is what actions/download-artifact puts there.
set -euo pipefail

here=$(cd "$(dirname "$0")" && pwd)

mapfile -t dirs < <(find . -maxdepth 1 -type d -name 'onnxruntime-linux-*' | sort)
if [ "${#dirs[@]}" -ne 1 ]; then
  echo "ERROR: expected exactly one onnxruntime-linux-* directory, found ${#dirs[@]}" >&2
  printf '%s\n' "${dirs[@]}"
  exit 1
fi
artifact=${dirs[0]#./}

so=$(find "$artifact" -name 'libonnxruntime.so' | head -1)
if [ -z "$so" ]; then
  echo "ERROR: libonnxruntime.so not found inside $artifact" >&2
  exit 1
fi

echo "=== $artifact ==="
echo "running on: $(ldd --version | head -1)"

echo
echo "########## 1/4 report ##########"
ls -lh "$so"
readelf -d "$so"
echo "--- glibc / GLIBCXX references:"
strings "$so" | grep '^GLIBC' | sort -u

echo
echo "########## 2/4 ABI ##########"
# The name is the claim. It may be absent, in which case the build took the
# toolchain default and we only report.
case "$artifact" in
  *-cxx11-abi-0) expected=0 ;;
  *-cxx11-abi-1) expected=1 ;;
  *-cxx11-abi)   expected=1 ;;
  *)             expected=none ;;
esac

# The two ABIs mangle std::string differently: the C++11 one references
# std::__cxx11::basic_string, the old gcc4-compatible COW one references
# std::basic_string (mangled with 'Ss'). Neither count is ever zero -- a
# -static-libstdc++ .so bundles libstdc++'s own dual-ABI symbols -- so these
# are informational and only the name is asserted on.
syms=$(nm "$so" | awk '{print $NF}' | sort -u)
new_abi=$(printf '%s\n' "$syms" | grep -c '__cxx11' || true)
old_abi=$(printf '%s\n' "$syms" | grep -cE '^_ZNSs|^_ZNSb' || true)
echo "name claims       : $expected"
echo "std::__cxx11 refs : $new_abi"
echo "old COW str refs  : $old_abi"

if [ "$expected" = 1 ] && [ "$new_abi" -le "$old_abi" ]; then
  echo "ERROR: name claims C++11 ABI but __cxx11 refs ($new_abi) do not exceed old-COW ($old_abi)" >&2
  exit 1
fi
if [ "$expected" = 0 ] && [ "$old_abi" -le "$new_abi" ]; then
  echo "ERROR: name claims old ABI but old-COW refs ($old_abi) do not exceed __cxx11 ($new_abi)" >&2
  exit 1
fi

echo
echo "########## 3/4 dlopen ##########"
cat > /tmp/test_load_so.c <<'EOF'
#include <dlfcn.h>
#include <stdio.h>
int main(int argc, char **argv) {
  void *h = dlopen(argv[1], RTLD_NOW);
  if (!h) { fprintf(stderr, "dlopen failed: %s\n", dlerror()); return 1; }
  if (!dlsym(h, "OrtGetApiBase")) { fprintf(stderr, "OrtGetApiBase not exported\n"); return 1; }
  printf("OK: %s loads and exports OrtGetApiBase\n", argv[1]);
  return 0;
}
EOF
cc -o /tmp/test_load_so /tmp/test_load_so.c -ldl
/tmp/test_load_so "$so"

echo
echo "########## 4/4 C API smoke test ##########"
g++ -std=c++17 -o /tmp/test_onnxruntime "$here/test_onnxruntime.cc" \
  -I"$artifact/include" -L"$(dirname "$so")" -lonnxruntime -Wl,-rpath,"$(dirname "$so")"
/tmp/test_onnxruntime

echo
echo "OK: $artifact passed all checks"
