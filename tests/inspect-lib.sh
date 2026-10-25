#!/usr/bin/env bash
# Print what a built library actually is: size, dynamic dependencies, and the
# glibc / GLIBCXX versions it references. Read-only -- nothing is executed.
#
# Usage: inspect-lib.sh [artifact-dir]
#        Omit the argument to auto-locate the single onnxruntime-linux-* dir.
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

so=$(find "$artifact" -name 'libonnxruntime.so' | head -1)
if [ -z "$so" ]; then
  echo "ERROR: libonnxruntime.so not found inside $artifact" >&2
  exit 1
fi

echo "=== artifact ==="
ls -lh "$so"

echo "=== dynamic dependencies (readelf -d) ==="
readelf -d "$so"

echo "=== glibc / GLIBCXX references (strings | grep ^GLIBC) ==="
strings "$so" | grep '^GLIBC' | sort -u
