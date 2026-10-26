#!/usr/bin/env bash
# Run the full check suite against one built artifact: report what it is, verify
# the ABI its name claims, dlopen it on the distro its glibc floor promises, and
# run the C API smoke test against it.
#
# Everything is derived from the artifact directory name, so the caller does not
# have to repeat the matrix:
#
#   onnxruntime-linux-<arch>-<glibc tag>-<...>[-cxx11-abi[-N]]
#
# Usage: test-artifact.sh <artifact-dir>
set -euo pipefail

artifact=${1:?usage: test-artifact.sh <artifact-dir>}
here=$(cd "$(dirname "$0")" && pwd)

case "$artifact" in
  *-x64-*)     arch=x86_64 ;;
  *-aarch64-*) arch=aarch64 ;;
  *) echo "ERROR: cannot tell the arch from '$artifact'" >&2; exit 1 ;;
esac

case "$artifact" in
  *glibc2_17*) glibc=2014 ;;  # manylinux2014 == CentOS 7 == glibc 2.17
  *glibc2_24*) glibc=2_24 ;;
  *glibc2_28*) glibc=2_28 ;;
  *) echo "ERROR: cannot tell the glibc target from '$artifact'" >&2; exit 1 ;;
esac

image="quay.io/pypa/manylinux_${glibc}_${arch}"
[ "$glibc" = 2014 ] && image="quay.io/pypa/manylinux2014_${arch}"

echo "### artifact : $artifact"
echo "### base     : $image"

echo
echo "########## 1/4 report ##########"
"$here/inspect-lib.sh" "$artifact"

echo
echo "########## 2/4 ABI ##########"
"$here/check-cxx11-abi.sh" "$artifact"

echo
echo "########## 3/4 loads on $image ##########"
"$here/check-runtime-compat.sh" "$image" "$artifact"

echo
echo "########## 4/4 C API smoke test ##########"
src="$here/test_onnxruntime.cc"
so=$(find "$artifact" -name 'libonnxruntime.so' | head -1)
g++ -std=c++17 -o /tmp/test_onnxruntime "$src" \
  -I"$artifact/include" -L"$(dirname "$so")" -lonnxruntime -Wl,-rpath,"$(dirname "$so")"
/tmp/test_onnxruntime

echo
echo "OK: $artifact passed all checks"
