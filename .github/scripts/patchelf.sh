#!/usr/bin/env bash

set -ex

version=$ONNXRUNTIME_VERSION

f=onnxruntime-linux-x64-gpu-$ONNXRUNTIME_VERSION
curl -SL -O https://github.com/microsoft/onnxruntime/releases/download/v$ONNXRUNTIME_VERSION/$f.tgz
tar xvf $f.tgz
rm $f.tgz

mv $f $f-patched
f=$f-patched
pushd $f/lib
ls -lh
readelf -d libonnxruntime.so.$version

rm -v libonnxruntime.so
rm -v libonnxruntime.so.1
mv -v libonnxruntime.so.$version libonnxruntime.so

readelf -d libonnxruntime.so

echo "----"
patchelf --set-soname libonnxruntime.so ./libonnxruntime.so
echo "----"
readelf -d libonnxruntime.so
popd
zip -r $f.zip $f
rm -rf $f
mv $f.zip ../..
