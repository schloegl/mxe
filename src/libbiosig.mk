# This file is part of MXE.
# See index.html for further information.

PKG             := libbiosig
$(PKG)_WEBSITE  := http://biosig.sf.net/
$(PKG)_DESCR    := libbiosig
$(PKG)_VERSION  := 2.0.2
$(PKG)_CHECKSUM := e94e6b4843d17b59eb5f2bb6d8508c63a2ab29ef6a712b8df5e2a6c3e3ed2db8
$(PKG)_SUBDIR   := biosig4c++-$($(PKG)_VERSION)
$(PKG)_FILE     := biosig4c++-$($(PKG)_VERSION).src.tar.gz
$(PKG)_URL      := http://sourceforge.net/projects/biosig/files/BioSig%20for%20C_C%2B%2B/src/$($(PKG)_FILE)
$(PKG)_DEPS     := cc suitesparse zlib libiberty libiconv libb64 lapack dcmtk tinyxml

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://biosig.sourceforge.io/download.html' | \
        $(GREP) biosig4c | \
        $(SED) -n 's_.*>v\([0-9]\.[0-9]\.[0-9]\)<.*_\1_p' | \
        $(SORT) -V | \
        tail -1
endef

define $(PKG)_BUILD_PRE

    echo $(MXE_CONFIGURE_OPTS)

    cd '$(1)' && ./configure \
        ac_cv_func_malloc_0_nonnull=yes \
        ac_cv_func_realloc_0_nonnull=yes \
        $(MXE_CONFIGURE_OPTS)

    # make sure NDEBUG is defined
    $(SED) -i '/NDEBUG/ s|#||g' '$(1)'/Makefile

    ### disables declaration of sopen from io.h (imported through unistd.h)

    $(SED) -i '/ sopen/ s|^/*|//|g' $(PREFIX)/$(TARGET)/include/io.h

    TARGET='$(TARGET)' $(MAKE) -C '$(1)' clean
    TARGET='$(TARGET)' $(MAKE) -C '$(1)' -j '$(JOBS)' \
		libbiosig.a libgdf.a  libphysicalunits.a \
		libbiosig.dll libgdf.dll libphysicalunits.dll

endef

define $(PKG)_BUILD_POST

    $(INSTALL) -m644 '$(1)/biosig.h'             '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/biosig2.h'            '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/gdftime.h'            '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/biosig-dev.h'         '$(PREFIX)/$(TARGET)/include/'

    $(INSTALL) -m644 '$(1)/libbiosig.a'          '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/libbiosig.def' 	 '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/libbiosig.dll.a' 	 '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/libbiosig.dll' 	 '$(PREFIX)/$(TARGET)/bin/'

    $(INSTALL) -m644 '$(1)/libgdf.a'             '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/libgdf.def' 		 '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/libgdf.dll.a' 	 '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/libgdf.dll'	 	 '$(PREFIX)/$(TARGET)/bin/'


    $(INSTALL) -m644 '$(1)/physicalunits.h'      '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/libphysicalunits.a'   '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/libphysicalunits.def' '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/libphysicalunits.dll.a' '$(PREFIX)/$(TARGET)/lib/'
    $(INSTALL) -m644 '$(1)/libphysicalunits.dll' '$(PREFIX)/$(TARGET)/bin/'

    $(INSTALL) -m644 '$(1)/libbiosig.pc'         '$(PREFIX)/$(TARGET)/lib/pkgconfig/'

    ### make release file
    rm -f $(PREFIX)/$($(PKG)_SUBDIR).$(TARGET).zip
    cd $(PREFIX)/$(TARGET) && zip $(PREFIX)/$($(PKG)_SUBDIR).$(TARGET).zip \
		include/biosig.h include/biosig-dev.h include/biosig2.h include/gdftime.h  \
		lib/libbiosig.a lib/libbiosig.def bin/libbiosig.dll lib/libbiosig.dll.a \
		lib/libgdf.a lib/libgdf.def bin/libgdf.dll lib/libgdf.dll.a \
		lib/libz.a lib/libcholmod.a lib/liblapack.a lib/libiconv.a lib/libiberty.a  \
		include/libiberty/*.h include/iconv.h \
		include/physicalunits.h \
		lib/libphysicalunits.a lib/libphysicalunits.def bin/libphysicalunits.dll lib/libphysicalunits.dll.a

    mkdir -p $(PREFIX)/release/$(TARGET)/include/
    cd $(PREFIX)/$(TARGET) && cp -r \
		include/biosig.h include/biosig-dev.h include/biosig2.h include/gdftime.h \
		include/libiberty include/iconv.h \
		include/physicalunits.h \
		$(PREFIX)/release/$(TARGET)/include/

    mkdir -p $(PREFIX)/release/$(TARGET)/lib/
    cd $(PREFIX)/$(TARGET) && cp -r \
		lib/libbiosig.a lib/libbiosig.def bin/libbiosig.dll lib/libbiosig.dll.a \
		lib/libgdf.a lib/libgdf.def bin/libgdf.dll lib/libgdf.dll.a \
		lib/libz.a lib/libcholmod.a lib/liblapack.a lib/libiconv.a lib/libiberty.a  \
		lib/libphysicalunits.a lib/libphysicalunits.def bin/libphysicalunits.dll lib/libphysicalunits.dll.a \
		$(PREFIX)/release/$(TARGET)/lib/

    mkdir -p $(PREFIX)/release/$(TARGET)/bin/
    -cp $(PREFIX)/$(TARGET)/bin/save2gdf.exe $(PREFIX)/release/$(TARGET)/bin/

    mkdir -p $(PREFIX)/release/matlab/
    -cp $(1)/mex/mex* $(PREFIX)/release/matlab/

    cd '$(1)/win32' && zip $(PREFIX)/$($(PKG)_SUBDIR).$(TARGET).zip *.bat README

    #exit -1
    ### these cause problems when compiling stimfit
    rm -rf '$(PREFIX)/$(TARGET)/lib/libphysicalunits.dll.a' \
	'$(PREFIX)/$(TARGET)/lib/libbiosig.dll.a' \
	'$(PREFIX)/$(TARGET)/lib/libgdf.dll.a'

endef


define $(PKG)_BUILD_i686-pc-mingw32
	$($(PKG)_BUILD_PRE)
	#HOME=/home/as TARGET=$(TARGET) $(MAKE) -C '$(1)' mexw32
	$($(PKG)_BUILD_POST)
endef

define $(PKG)_BUILD_i686-w64-mingw32
	$($(PKG)_BUILD_PRE)
	#TARGET=$(TARGET) $(MAKE) -C '$(1)' mexw32
	$($(PKG)_BUILD_POST)
endef

define $(PKG)_BUILD_x86_64-w64-mingw32
	$($(PKG)_BUILD_PRE)
	#TARGET=$(TARGET) $(MAKE) -C '$(1)' mexw64
	$($(PKG)_BUILD_POST)
endef

