#!/usr/bin/env bash
# Verify a built libonnxruntime.so actually loads on the distro its glibc floor
# promises, by dlopen-ing it inside the matching manylinux *base* image -- which
# is exactly that distro, with exactly the libstdc++ a user there would have.
#
# Usage: check-runtime-compat.sh <artifact-dir> <base-image>
#
#   check-runtime-compat.sh onnxruntime-linux-x64-glibc2_17-Release-1.31.0 \
#       quay.io/pypa/manylinux2014_x86_64
#
# The glibc floor alone is not enough: the C++ standard library is versioned
# separately (GLIBCXX_3.4.x), so a .so can satisfy glibc 2.17 and still fail to
# load on CentOS 7 with "version `GLIBCXX_3.4.29' not found". Only running it on
# the real thing settles it.
set -euo pipefail

# Usage: check-runtime-compat.sh <base-image> [artifact-dir]
image=${1:?usage: check-runtime-compat.sh <base-image> [artifact-dir]}
artifact=${2:-}
if [ -z "$artifact" ]; then
  mapfile -t dirs < <(find . -maxdepth 1 -type d -name 'onnxruntime-linux-*' | sort)
  if [ "${#dirs[@]}" -ne 1 ]; then
    echo "ERROR: expected exactly one artifact directory, found ${#dirs[@]}" >&2
    printf '%s\n' "${dirs[@]}"
    exit 1
  fi
  artifact=${dirs[0]#./}
fi

so=$(find "$artifact" -name 'libonnxruntime.so' | head -1)
if [ -z "$so" ]; then
  echo "ERROR: libonnxruntime.so not found inside $artifact" >&2
  exit 1
fi
libdir=$(cd "$(dirname "$so")" && pwd)

cat > /tmp/test_load_so.c <<'EOF'
#include <dlfcn.h>
#include <stdio.h>
int main(int argc, char **argv) {
  if (argc != 2) {
    fprintf(stderr, "usage: %s <lib>\n", argv[0]);
    return 2;
  }
  void *h = dlopen(argv[1], RTLD_NOW);
  if (!h) {
    fprintf(stderr, "dlopen failed: %s\n", dlerror());
    return 1;
  }
  if (!dlsym(h, "OrtGetApiBase")) {
    fprintf(stderr, "OrtGetApiBase not exported\n");
    return 1;
  }
  printf("OK: %s loads and exports OrtGetApiBase\n", argv[1]);
  return 0;
}
EOF

echo "=== loading it in $image ==="
echo "--- this image's C library:"
docker run --rm "$image" ldd --version | head -1

docker run --rm \
  -v /tmp/test_load_so.c:/test_load_so.c:ro \
  -v "$libdir":/lib:ro \
  "$image" \
  bash -c '
    set -e
    echo "--- this image'"'"'s C++ library:"
    ls /usr/lib*/libstdc++.so.6* 2>/dev/null || ls /lib*/libstdc++.so.6* 2>/dev/null || echo "(none)"
    cc -o /tmp/test_load_so /test_load_so.c -ldl
    /tmp/test_load_so /lib/libonnxruntime.so
  '
