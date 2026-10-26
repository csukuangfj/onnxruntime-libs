# Introduction

This repo provides pre-compiled onnxruntime shared and static libraries
for various platforms.

Please visit https://github.com/csukuangfj/onnxruntime-libs/releases
to download pre-compiled onnxruntime libraries.

Note:

 - Code for building shared libraries: https://github.com/csukuangfj/onnxruntime-libs/tree/master/.github/workflows
 - Code for building static libraries: https://github.com/csukuangfj/onnxruntime-build/tree/main/.github/workflows

## Using from SwiftPM

```swift
.executableTarget(
    name: "MyApp",
    dependencies: [.product(name: "OnnxRuntimeKit", package: "onnxruntime-libs")]
)
```

The Apple xcframeworks are built with `--no_telemetry`, so they have no
transitive `libz` / `libsqlite3` dependency and need no extra `linkerSettings`
on your executable target. `spm-examples/` shows a working setup for each
platform.

## `_GLIBCXX_USE_CXX11_ABI` of the Linux libraries

| `_GLIBCXX_USE_CXX11_ABI` | meaning |
| --- | --- |
| `1` | C++11 `std::string` — the default of every stock gcc >= 5 |
| `0` | old gcc4-compatible COW `std::string` — the default of Red Hat SCL devtoolset |

Whether it is observable depends on the product:

| product | does the ABI reach the consumer? | published |
| --- | --- | --- |
| shared (`onnxruntime-linux-*`) | **no** — the library links libstdc++ statically and the seam is the pure C API, so no `std::string` crosses | one variant, **no** marker |
| static (`*_static_lib-*`) | **yes** — the archive lands in the consumer's binary and shares its libstdc++ | see below |

Static (`*_static_lib-*`) naming:

| build | toolchain | artifacts |
| --- | --- | --- |
| x86_64 `glibc2_17`, aarch64 `glibc2_17` | stock gcc 11 | `-cxx11-abi-0` and `-cxx11-abi-1` |
| x86_64 `glibc2_24`/`glibc2_28`, aarch64 `glibc2_24`/`glibc2_28` | stock gcc | one variant, no marker |

Every build uses a stock gcc built from source. Red Hat SCL devtoolset is
deliberately not used: it is configured `--with-default-libstdcxx-abi=gcc4-compatible`,
so its headers force `_GLIBCXX_USE_CXX11_ABI=0` and ignore
`-D_GLIBCXX_USE_CXX11_ABI=1` — a toolchain that cannot produce the C++11 ABI at
all.

For static libraries the two variants must not be mixed: doing so corrupts
the heap at startup with
`free(): invalid pointer`, because `std::filesystem::path`'s non-inline members
(`_M_split_cmpts`, `operator=`) live in libstdc++ and are laid out according to
this macro. Most projects want the C++11 ABI build.

