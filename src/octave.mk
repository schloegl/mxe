
# This file is part of MXE.
# See index.html for further information.

PKG             := octave
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.6.4
$(PKG)_CHECKSUM := 3cc9366b6dbbd336eaf90fe70ad16e63705d82c4
$(PKG)_SUBDIR   := octave-$($(PKG)_VERSION)
$(PKG)_FILE     := octave-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := ftp://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := arpack blas curl fftw fltk fontconfig freetype gcc glpk gnuplot graphicsmagick hdf5 lapack libgomp ncurses pcre pthreads qhull qrupdate readline suitesparse termcap texinfo zlib
## pstoedit qscintilla qt ### FIXME: these are dependencies for Octave, but do not build yet

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/octave/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="octave-\([0-9][^"]*\)\.tar\.gz".*,\1,p' | \
    head -1
endef


define $(PKG)_BUILD
    if [ $(BUILD_SHARED) = yes ]; then \
      $(INSTALL) -d '$(PREFIX)/$(TARGET)/bin'; \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(TARGET)-ar' --ld '$(TARGET)-gcc' '$(PREFIX)/$(TARGET)/lib/libuuid.a'; \
      $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/lib/libuuid.dll.a' '$(PREFIX)/$(TARGET)/lib/libuuid.dll.a'; \
      $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/lib/libuuid.dll' '$(PREFIX)/$(TARGET)/bin/libuuid.dll'; \
      rm -f '$(PREFIX)/$(TARGET)/lib/libuuid.dll'; \
    fi

    mkdir '$(1)/.build'
    cd '$(1)' && autoreconf --force -W none

    ### make sure pcre-config of host is used
    $(SED) -i 's,pcre-config,$(PREFIX)/$(TARGET)/bin/pcre-config,g' '$(1)/configure'

    # configure
    cd '$(1)/.build' && '../configure' \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-static \
        --disable-shared \
        --enable-openmp \
        FLTK_CONFIG="$(PREFIX)/bin/$(TARGET)-fltk-config" \
        PKG_CONFIG="$(TARGET)-pkg-config" \
        LIBS='-lsuitesparseconfig -lumfpack -lamd' \
        BUILD_CC=g++ \
        gl_cv_func_gettimeofday_clobber=no

        #BUILD_CXX="g++" \

    ## We want both of these install steps so that we install in the
    ## location set by the configure --prefix option, and the other
    ## in a directory tree that will have just Octave files.
    $(MAKE_SHARED_FROM_STATIC) --ar '$(TARGET)-ar' --ld '$(TARGET)-g++' -C '$(1)/.build' -j '$(JOBS)' install

    $(MAKE) -C '$(1)/.build' -j '$(JOBS)' DESTDIR=$(PREFIX)/../octave install

endef

$(PKG)_BUILD_i686-pc-mingw32 =
$(PKG)_BUILD_i686-w64-mingw32 =
$(PKG)_BUILD_x86_64-w64-mingw32 =
