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
| `1` — C++11 `std::string`, the default of every stock gcc >= 5 | name ends with `-cxx11-abi` |
| `0` — old gcc4-compatible COW `std::string`, the default of Red Hat SCL devtoolset | no `-cxx11-abi` marker |

The rule is: the name of an `onnxruntime-linux-*.zip` asset ends with
`-cxx11-abi` if and only if it was built with `_GLIBCXX_USE_CXX11_ABI=1`.

Which ABI is available depends on the **toolchain**, not on the glibc tag:

| build | toolchain | available ABI |
| --- | --- | --- |
| x86_64 `glibc2_17` | Red Hat SCL devtoolset | `0` only |
| x86_64 `glibc2_24` | stock gcc 11 (`manylinux_2_24-x86_64-gcc11`) | `1` and `0` |
| x86_64 `glibc2_28` | stock gcc | `1` and `0` |
| aarch64 `glibc2_17` | stock gcc 11 (`manylinux2014-aarch64-gcc11`) | `1` and `0` |
| aarch64 `glibc2_24` | stock gcc 12 (`manylinux_2_24-aarch64-gcc12`) | `1` and `0` |
| aarch64 `glibc2_28` | stock gcc | `1` and `0` |

Only the x86_64 `glibc2_17` build is stuck at the old ABI. Its toolchain is
Red Hat SCL devtoolset, which is configured
`--with-default-libstdcxx-abi=gcc4-compatible`: its headers force
`_GLIBCXX_USE_CXX11_ABI=0` and ignore `-D_GLIBCXX_USE_CXX11_ABI=1`, so the
C++11 ABI cannot be produced there at all. Its artifacts are always untagged.

Mixing the two variants corrupts the heap at startup with
`free(): invalid pointer`, because `std::filesystem::path`'s non-inline members
(`_M_split_cmpts`, `operator=`) live in libstdc++ and are laid out according to
this macro. Most projects want the `-cxx11-abi` build.

