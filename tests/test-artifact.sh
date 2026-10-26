#!/usr/bin/env bash
# Everything that must hold for a built onnxruntime artifact, in one place.
# Runs *inside* the target distro -- the workflow is what puts it in the matching
# manylinux container; this script just runs.
#
#   1. report  size, dynamic deps, glibc/GLIBCXX versions
#   2. dlopen  it is actually usable here
#   3. smoke   call the C API end to end
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
echo "########## 1/3 report ##########"
echo "--- artifact contents:"
ls -lh "$artifact"
echo "--- the library itself:"
ls -lh "$so"
readelf -d "$so"
echo "--- glibc / GLIBCXX references:"
strings "$so" | grep '^GLIBC' | sort -u

echo
echo "########## 2/3 dlopen ##########"
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
echo "########## 3/3 C API smoke test ##########"
# Compile as C: the C API header defines NO_EXCEPTION as `noexcept` on function
# pointer types, which is a C++17 language feature -- gcc 6 (manylinux_2_24)
# cannot parse it. Under C the macro is empty and the header is plain C. This
# test only calls OrtGetApiBase(), so C is the right language for it anyway.
cc -x c -o /tmp/test_onnxruntime "$here/test_onnxruntime.cc" \
  -I"$artifact/include" -L"$(dirname "$so")" -lonnxruntime -Wl,-rpath,"$(dirname "$so")"
/tmp/test_onnxruntime

echo
echo "OK: $artifact passed all checks"
