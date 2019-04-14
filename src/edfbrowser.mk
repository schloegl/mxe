# This file is part of MXE.
# See index.html for further information.

PKG             := edfbrowser
$(PKG)_WEBSITE  := https://www.teuniz.net/edfbrowser/
$(PKG)_DESCR    := EDFbrowser
$(PKG)_IGNORE   := 
$(PKG)_CHECKSUM := 1805c78ab511822baa5e62beed0cf07cd46c8d51
$(PKG)_SUBDIR   := edfbrowser_150_source
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://www.teuniz.net/edfbrowser/$($(PKG)_FILE)
                   https://gitlab.com/Teuniz/EDFbrowser/releases
$(PKG)_GH_CONF  := Teuniz/EDFbrowser/releases v
$(PKG)_QT_DIR   := qt5
$(PKG)_DEPS     := cc qtbase


define $(PKG)_BUILD

    cd '$(1)' && $(PREFIX)/$(TARGET)/$($(PKG)_QT_DIR)/bin/qmake

    $(MAKE) -C '$(1)'
    
    $(INSTALL) '$(1)/release/edfbrowser.exe' '$(PREFIX)/$(TARGET)/bin/'

endef

