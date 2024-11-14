#!/usr/bin/env bash

version=$ONNXRUNTIME_VERSION

files=(
onnxruntime-linux-aarch64-glibc2_17-Debug-$version
onnxruntime-linux-aarch64-glibc2_17-MinSizeRel-$version
onnxruntime-linux-aarch64-glibc2_17-Release-$version
onnxruntime-linux-aarch64-glibc2_17-RelWithDebInfo-$version
onnxruntime-linux-arm-$version
onnxruntime-linux-x64-glibc2_17-Debug-$version
onnxruntime-linux-x64-glibc2_17-MinSizeRel-$version
onnxruntime-linux-x64-glibc2_17-Release-$version
onnxruntime-linux-x64-glibc2_17-RelWithDebInfo-$version
)

for f in ${files[@]}; do
  curl -SL -O https://github.com/csukuangfj/onnxruntime-libs/releases/download/v1.17.1/$f.zip
  unzip $f.zip
  rm $f.zip
  mv $f $f-patched
  f=$f-patched
  pushd $f/lib
  rm -v libonnxruntime.so.$version

  readelf -d libonnxruntime.so
  echo "----"
  patchelf --set-soname libonnxruntime.so ./libonnxruntime.so
  echo "----"
  readelf -d libonnxruntime.so
  popd
  zip -r $f.zip $f
  rm -rf $f
  mv $f.zip ../..
done
