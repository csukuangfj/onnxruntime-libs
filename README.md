# Introduction

This repo provides pre-compiled onnxruntime shared and static libraries
for various platforms.

Please visit https://github.com/csukuangfj/onnxruntime-libs/releases
to download pre-compiled onnxruntime libraries.

Note:

 - Code for building shared libraries: https://github.com/csukuangfj/onnxruntime-libs/tree/master/.github/workflows
 - Code for building static libraries: https://github.com/csukuangfj/onnxruntime-build/tree/main/.github/workflows

## `_GLIBCXX_USE_CXX11_ABI` of the Linux libraries

Linux static and shared libraries are published in two variants. A single binary must not
mix them, so pick the one that matches the compiler you link against.

| `_GLIBCXX_USE_CXX11_ABI` | artifact name |
| --- | --- |
| `1` — C++11 `std::string`, the default of every stock gcc >= 5 | see the table below |
| `0` — old gcc4-compatible COW `std::string`, the default of Red Hat SCL devtoolset | see the table below |

Which ABI is available depends on the **toolchain**, not on the glibc tag:

| build | toolchain | available ABI |
| --- | --- | --- |
| x86_64 `glibc2_17` | stock gcc 11 (`manylinux2014-x86_64-gcc11`) | `1` and `0` |
| x86_64 `glibc2_24` | stock gcc 11 (`manylinux_2_24-x86_64-gcc11`) | `1` and `0` |
| x86_64 `glibc2_28` | stock gcc | `1` and `0` |
| aarch64 `glibc2_17` | stock gcc 11 (`manylinux2014-aarch64-gcc11`) | `1` and `0` |
| aarch64 `glibc2_24` | stock gcc 11 (`manylinux_2_24-aarch64-gcc11`) | `1` and `0` |
| aarch64 `glibc2_28` | stock gcc | `1` and `0` |

Every build uses a stock gcc built from source, so both ABIs are available on
every glibc base. Red Hat SCL devtoolset is deliberately not used: it is
configured `--with-default-libstdcxx-abi=gcc4-compatible`, so its headers force
`_GLIBCXX_USE_CXX11_ABI=0` and ignore `-D_GLIBCXX_USE_CXX11_ABI=1` — a toolchain
that cannot produce the C++11 ABI at all.

Naming differs between the static and shared products:

| product | naming |
| --- | --- |
| static (`*_static_lib-*`) x86_64/aarch64 `glibc2_17` | both variants published as `-cxx11-abi-0` and `-cxx11-abi-1` |
| static (`*_static_lib-*`) x86_64/aarch64 `glibc2_24`/`glibc2_28` | one variant, **no** marker |
| shared (`onnxruntime-linux-*`) | `-cxx11-abi` suffix iff built with `_GLIBCXX_USE_CXX11_ABI=1` |

Mixing the two variants corrupts the heap at startup with
`free(): invalid pointer`, because `std::filesystem::path`'s non-inline members
(`_M_split_cmpts`, `operator=`) live in libstdc++ and are laid out according to
this macro. Most projects want the C++11 ABI build.

