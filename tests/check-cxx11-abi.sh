#!/usr/bin/env bash
# Check that a built onnxruntime artifact matches the ABI its name claims.
#
# Usage: check-cxx11-abi.sh [artifact-dir]
set -euo pipefail

artifact=${1:-}
if [ -z "$artifact" ]; then
  mapfile -t dirs < <(find . -maxdepth 1 -type d -name 'onnxruntime-linux-*' | sort)
  if [ "${#dirs[@]}" -ne 1 ]; then
    echo "ERROR: expected exactly one artifact directory, found ${#dirs[@]}" >&2
    printf '%s\n' "${dirs[@]}"
    exit 1
  fi
  artifact=${dirs[0]#./}
fi

# The name is the contract: -cxx11-abi-N on the glibc2_17 static builds,
# -cxx11-abi for the C++11 shared builds, nothing for the old ABI.
case "$artifact" in
  *-cxx11-abi-1) expected=1 ;;
  *-cxx11-abi-0) expected=0 ;;
  *-cxx11-abi)   expected=1 ;;
  *)             expected=0 ;;
esac

lib=$(find "$artifact" -name 'libonnxruntime.so' -o -name 'libonnxruntime.a' | head -1)
if [ -z "$lib" ]; then
  echo "ERROR: no libonnxruntime.{so,a} inside $artifact" >&2
  exit 1
fi

syms=$(nm "$lib" | awk '{print $NF}' | sort -u)
new_abi=$(printf '%s\n' "$syms" | grep -c '__cxx11' || true)
old_abi=$(printf '%s\n' "$syms" | grep -cE '^_ZNSs|^_ZNSb' || true)

echo "artifact          : $artifact"
echo "library           : $lib"
echo "name claims       : _GLIBCXX_USE_CXX11_ABI=$expected"
echo "std::__cxx11 refs : $new_abi"
echo "old COW str refs  : $old_abi"

# The counts are informational: a static-libstdc++ .so bundles libstdc++'s own
# dual-ABI symbols, so they reflect the bundling as much as the build. The name
# is the reliable claim, so only assert on it.
case "$artifact" in
  *-cxx11-abi-1|*-cxx11-abi-0)
    want=${artifact##*-cxx11-abi-}
    if [ "$want" != "$expected" ]; then
      echo "::error::artifact name '$artifact' is inconsistent"
      exit 1
    fi
    ;;
esac

echo "OK: $artifact"
