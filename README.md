# MXE (M cross environment)

[![License][license-badge]][license-page]

[license-page]: LICENSE.md
[license-badge]: https://img.shields.io/badge/License-MIT-brightgreen.svg

[![Async Chat (Trial))](https://img.shields.io/badge/zulip-join_chat-brightgreen.svg)](https://mxe.zulipchat.com/)

MXE (M cross environment) is a GNU Makefile that compiles a cross
compiler and cross compiles many free libraries. This repository is derived from
[MXE](https://github.com/mxe/mxe), and extended for compiling the following tools:
 - [libiosig/biosig-tools](http://biosig.sourceforge.net/)
 - [sigviewer](https://github.com/cbrnr/sigviewer)
 - [stimfit](https://github.com/neurodroid/stimfit)-lite (without python)
 - [edfbrowswer](https://www.teuniz.net/edfbrowser/)
It compiles also required prerequisites, and many other packages.

## Supported Toolchains

  * Runtime: MinGW-w64
  * Host Triplets:
    - `i686-w64-mingw32`
    - `x86_64-w64-mingw32`
  * Packages:
    - static
    - (shared - not tested here, use https://github.com/mxe instead)
  * GCC Threading Libraries (`winpthreads` is always available):
    - [posix](https://github.com/mxe/mxe/pull/958) [(default)](https://github.com/mxe/mxe/issues/2258)
    - win32 (supported by limited amount packages)
  * GCC Exception Handling:
    - Default
      - i686: sjlj
      - x86_64: seh
    - [Alternatives (experimental)](https://github.com/mxe/mxe/pull/1664)
      - i686: dw2
      - x86_64: sjlj

Please see [mxe.cc](https://mxe.cc/) for further information and package support matrix.

## Build Dependencies

For some packages additional dependencies are required to be installed in order to build:

* Python 3

## Usage

You can use the `make` command to start the build.  

Below *an example* of cross-compiling the GTK3 project to one statically linked Windows 64-bit library:

```sh
make gtk3 -j 8 MXE_TARGETS='x86_64-w64-mingw32.static'
```

Please see [mxe.cc](https://mxe.cc/) for more information about how-to build the MXE project.

## Packages

Within the [MXE makefiles](src) we either define `$(PKG)_GH_CONF` or `$(PKG)_URL`, which will be used to download the package.  
Next the checksum will be validated of the downloaded archive file (sha256 checksum).

Updating a package or updating checksum is all possible using the make commands, see [usage for more info](https://mxe.cc/#usage).

## Shared Library Notes
There are several approaches to recursively finding DLL dependencies (alphabetical list):
  * [go script](https://github.com/desertbit/gml/blob/master/cmd/gml-copy-dlls/main.go)
  * [pe-util](https://github.com/gsauthof/pe-util) packaged with [mxe](https://github.com/mxe/mxe/blob/master/src/pe-util.mk)
  * [python script](https://github.com/mxe/mxe/blob/master/tools/copydlldeps.py)
  * [shell script](https://github.com/mxe/mxe/blob/master/tools/copydlldeps.md)
