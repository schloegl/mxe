# This file is part of MXE.
# See index.html for further information.

PKG             := sigviewer
$(PKG)_IGNORE   := 
$(PKG)_VERSION  := 0.6.5
$(PKG)_CHECKSUM := 452b36a5ec0eb56438f295454969f558917786afaa21100203584021ce145ca4
$(PKG)_SUBDIR   := sigviewer-v$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://git.ista.ac.at/alois.schloegl/sigviewer/-/archive/v$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_QT_DIR   := qt5
$(PKG)_DEPS     := biosig libxdf qtbase

define $(PKG)_UPDATE
    wget -q -O- 'http://biosig.sourceforge.net/download.html' | \
    $(SED) -n 's_.*>libbiosig, version \([0-9]\.[0-9]\.[0-9]\).*tar.gz_\1_ip'
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && CFLAGS=-fstack-protector CXXFLAGS=-fstack-protector && \
        LIBS='-l$(PREFIX)/$(TARGET)/lib/libtinyxml.a -l$(PREFIX)/$(TARGET)/$($(PKG)_QT_DIR)/plugins/platforms/libqwindows.a' \
        $(PREFIX)/$(TARGET)/$($(PKG)_QT_DIR)/bin/qmake sigviewer.pro

    $(MAKE) -C '$(1)'

    $(INSTALL) '$(1)'/bin/release/sigviewer.exe $(PREFIX)/$(TARGET)/bin/$(PKG).exe
endef
