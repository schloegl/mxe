# This file is part of MXE.
# See index.html for further information.

PKG             := gnuplot
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.2.0
$(PKG)_CHECKSUM := 7dfe6425a1a6b9349b1fb42dae46b2e52833b13e807a78a613024d6a99541e43
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://sourceforge.net/projects/gnuplot/files/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libiconv

define $(PKG)_UPDATE
    $(WGET) -q -O- http://www.gnuplot.info/index.html | \
    $(SED) -n 's_.*Release.*announce[_\.]([0-9]\.[0-9].\[0-9]).*gnuplot.*_\1_ip' | \
    head -1
endef

define $(PKG)_BUILD
    make -C '$(1)/config/mingw' CC='$(TARGET)-gcc' CXX='$(TARGET)-g++' RC='$(TARGET)-windres' -j '$(JOBS)' TARGET=gnuplot.exe gnuplot.exe
    make -C '$(1)/config/mingw' CC='$(TARGET)-gcc' CXX='$(TARGET)-g++' RC='$(TARGET)-windres' -j '$(JOBS)' TARGET=wgnuplot.exe wgnuplot.exe
    make -C '$(1)/config/mingw' CC='$(TARGET)-gcc' CXX='$(TARGET)-g++' RC='$(TARGET)-windres' -j '$(JOBS)' wgnuplot.mnu

    $(INSTALL) -d '$(PREFIX)/$(TARGET)/bin'
    $(INSTALL) -m755 '$(1)/config/mingw/gnuplot.exe' '$(PREFIX)/$(TARGET)/bin/'
    $(INSTALL) -m755 '$(1)/config/mingw/wgnuplot.exe' '$(PREFIX)/$(TARGET)/bin/'
    $(INSTALL) -m644 '$(1)/src/win/wgnuplot.mnu' '$(PREFIX)/$(TARGET)/bin/'

endef

$(PKG)_BUILD_x86_64-w64-mingw32 =
$(PKG)_BUILD_i686-w64-mingw32 =
