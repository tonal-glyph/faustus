version := 2.14.3

system	?= $(shell uname -s)

ifeq ($(system), Darwin)
LIB_EXT = dylib
else
ifneq ($(findstring MINGW, $(system)),)
LIB_EXT = dll
EXE = .exe
else
LIB_EXT = so
endif
endif

DESTDIR ?=
PREFIX ?= /usr/local
CROSS=i586-mingw32msvc-
BUILDLOCATION := build
DEBUGFOLDER := faustdebug
BINLOCATION := $(BUILDLOCATION)/bin
LIBLOCATION := $(BUILDLOCATION)/lib

MAKEFILE := Makefile.unix

prefix := $(DESTDIR)$(PREFIX)
arch   := $(wildcard architecture/*.*)
mfiles := $(wildcard examples/Makefile.*)
vname := faust-$(version)-$(shell date +%y%m%d.%H%M%S)
zname := faust-$(version)

.PHONY: all world benchmark httpd remote win32 ios ios-llvm asmjs wasm sound2faust

# The main targets

compiler : updatesubmodules
	$(MAKE) -C $(BUILDLOCATION) cmake BACKENDS=regular.cmake TARGETS=regular.cmake
	$(MAKE) -C $(BUILDLOCATION)

most : updatesubmodules
	$(MAKE) -C $(BUILDLOCATION) cmake BACKENDS=most.cmake TARGETS=most.cmake
	$(MAKE) -C $(BUILDLOCATION)

developer : updatesubmodules
	$(MAKE) -C $(BUILDLOCATION) cmake BACKENDS=all.cmake TARGETS=developer.cmake
	$(MAKE) -C $(BUILDLOCATION)

all : updatesubmodules
	$(MAKE) -C $(BUILDLOCATION) cmake BACKENDS=all.cmake TARGETS=all.cmake
	$(MAKE) -C $(BUILDLOCATION)

travis : updatesubmodules
	$(MAKE) -C $(BUILDLOCATION) cmake BACKENDS=backends.cmake TARGETS=regular.cmake
	$(MAKE) -C $(BUILDLOCATION)

# Universal and native: special developer modes

universal :
	$(MAKE) -C $(BUILDLOCATION) universal
	@echo
	@echo "### Universal mode is ON"
	@echo "### You need to recompile"
	@echo "### Use 'make native' to revert"

native :
	$(MAKE) -C $(BUILDLOCATION) native
	@echo
	@echo "### Universal mode is OFF"
	@echo "### You need to recompile"

# make world (MAINTAINERS TARGET): This builds all the common targets for a
# fairly complete Faust installation: Faust compiler (including the LLVM
# backend) and library, sound2faust utility, OSC and HTTPD libraries (both
# static and dynamic).

# CAVEAT: END USERS should note that this target requires a substantial amount
# of additional dependencies (in particular, LLVM) which aren't readily
# pre-installed on most systems, hence you should NOT use this target (which
# is mostly aimed at package maintainers) unless you KNOW WHAT YOU'RE DOING.
# Don't complain if the target doesn't build for you, use one of the standard
# build targets instead. You have been warned! :)

# MAINTAINERS: Once the "remote" target is readily supported on most
# platforms, it should be added here. This requires Jack2 1.9.10 or later
# which isn't regularly installed on most systems at present, so we skip this
# target for now.

world : all
	$(MAKE) -C tools/sound2faust

benchmark : developer
	$(MAKE) -C tools/benchmark all

remote : developer
	$(MAKE) -C embedded/faustremote/RemoteServer all
	$(MAKE) -C embedded/faustremote all

win32 :
	$(MAKE) -C compiler -f $(MAKEFILE) prefix=$(prefix) CXX=$(CROSS)g++
	$(MAKE) -C architecture/osclib CXX=$(CROSS)g++ system=Win32

debug :
	$(MAKE) -C $(BUILDLOCATION) FAUSTDIR=faustdebug CMAKEOPT=-DCMAKE_BUILD_TYPE=Debug
#	$(MAKE) -C compiler debug -f $(MAKEFILE) prefix=$(prefix)

plugin :
	$(MAKE) -C compiler plugin -f $(MAKEFILE) prefix=$(prefix)

ioslib :
	$(MAKE) -C $(BUILDLOCATION) ioslib

asmjs :
	$(MAKE) -C $(BUILDLOCATION) asmjslib

wasm :
	$(MAKE) -C $(BUILDLOCATION) wasmlib

sound2faust :
	$(MAKE) -C tools/sound2faust

.PHONY: clean install uninstall dist parser help format

help :
	@echo "===== Faust main makefile ====="
	@echo "Main targets"
	@echo " 'compiler' (def): builds the Faust compiler (without the LLVM backend), and the Faust osc and httpd libraries"
	@echo " 'most'          : builds the Faust compiler with LLVM backend and every static libraries"
	@echo " 'developer'     : builds the Faust compiler with every possible backends and every static libraries"
	@echo " 'all'           : builds the Faust compiler with every possible backends and every static and dynamic libraries"
	@echo
	@echo " 'install'       : install the compiler, tools and the architecture files in $(prefix)/bin $(prefix)/share/faust $(prefix)/include/faust"
	@echo " 'clean'         : remove all object files"
	@echo
	@echo "Other targets"
	@echo " 'debug'         : similar to 'all' target but with debug info. Output is in $(BUILDLOCATION)/$(DEBUGFOLDER)"
	@echo " 'asmjs'         : builds the Faust asm-js library"
	@echo " 'wasm'          : builds the Faust web assembly library"
	@echo " 'benchmark'     : builds the benchmark tools (see tools/benchmark)"
	@echo " 'remote'        : builds the libfaustremote.a library and the Faust RemoteServer"
	@echo " 'sound2faust'   : builds the sound2faust utilities (requires libsndfile)"
	@echo " 'parser'        : generates the parser from the lex and yacc files"
	@echo
	@echo "Distribution target"
	@echo " 'world'         : the 'all' target and sound2faust"
	@echo
	@echo "Platform specific targets:"
	@echo " 'universal'     : [MacOSX] switch to universal binaries mode"
	@echo " 'native'        : [MacOSX] switch to native mode"
	@echo " 'win32'         : [linux]  used for win cross-compilation (requires mingw32-binutils package)"
	@echo " 'ioslib'        : [iOS] build the Faust static library for iOS"
	@echo
	@echo "Utilities targets:"
	@echo " 'man'              : generate the Faust man page"
	@echo " 'doc'              : generate the documentation using doxygen"
	@echo " 'doclib'           : generate the documentation of the Faust libraries"
	@echo " 'updatesubmodules' : update the libraries submodule"
	@echo " 'devinstall'       : install the benchmark tools"
	@echo " 'uninstall'        : undo what install did"
	@echo " 'dist'             : make a Faust distribution as a .zip file"
	@echo " 'log'              : make a changelog file"
	@echo " 'format'           : clang-format all src files"
	@echo

readme:
	@cat resources/man-header.txt
	@build/bin/faust -h | sed -e 's/\(-[a-zA-Z][a-zA-Z]*\)/**\1**/' \
			| sed -e 's/\(--[a-zA-Z][a-zA-Z-]*\)/**\1**/' \
			| sed -e 's/</\\</g' \
			| sed '/-----*/ G' \
			| sed '/\.$$/ G'
	@cat resources/man-footer.txt



# 	@echo "Usage : 'make; sudo make install'"
# 	@echo "For http support : 'make httpd; make; sudo make install' (requires GNU libmicrohttpd)"
# 	@echo "make or make all : compile the Faust compiler and osc support library"
# 	@echo "make httpd : compile httpdlib (requires GNU libmicrohttpd)"
# 	@echo "make dynamic : compile httpd & osc supports as dynamic libraries"
# 	@echo "make asmjs : compile asmjs libfaust.js"
# 	@echo "make wasm : compile wasm libfaust-wasm.js"
# 	@echo "make universal : on OSX, compile 32/64bits version of compiler and libraries"
# 	@echo "make light : only compile C/C++ backend (to avoid dependency with LLVM)"
# 	@echo "make debug : produce a debug version of compiler and libraries"
# 	@echo "make sound2faust : compile sound to DSP file converter"
# 	@echo "make remote : compile remote components used by FaustLive"
# 	@echo "make parser : generate the parser from the lex and yacc files"
# 	@echo "make clean : remove all object files"
# 	@echo "make doc : generate the documentation using doxygen"
# 	@echo "make updatesubmodules : update the libraries submodule"
# 	@echo "make doclib : generate the documentation of the faust libraries"
# 	@echo "make install : install the compiler, tools and the architecture files in $(prefix)/bin $(prefix)/share/faust $(prefix)/include/faust"
# 	@echo "make uninstall : undo what install did"
# 	@echo "make dist : make a Faust distribution as a .zip file"
# 	@echo "make log : make a changelog file"

parser :
	$(MAKE) -C compiler/parser

clean :
	$(MAKE) -C build clean
#	$(MAKE) -C architecture/osclib clean
#	$(MAKE) -C architecture/httpdlib/src clean
	$(MAKE) -C embedded/faustremote/RemoteServer clean
	$(MAKE) -C embedded/faustremote clean
	$(MAKE) -C tools/sound2faust clean
	$(MAKE) -C tools/benchmark clean

doc :
	$(MAKE) -C compiler -f $(MAKEFILE) doc

format :
	find compiler -path compiler/parser -prune -o -iname '*.cpp' -execdir clang-format-mp-5.0 -i -style=file {} \;
	find compiler -path compiler/parser -prune -o -iname '*.hh' -execdir clang-format-mp-5.0 -i -style=file {} \;
	find compiler -path compiler/parser -prune -o -iname '*.h' -execdir clang-format-mp-5.0 -i -style=file {} \;

# the target 'lib' can be used to init and update the libraries submodule
updatesubmodules :
	if test -d .git; then git submodule update --init; fi


doclib : updatesubmodules
	./libraries/generateDoc

#man :
#	pandoc --standalone --to man compiler/README.md -o faust.1

man :
	make -C documentation/man man

install :
	make -C $(BUILDLOCATION) install DESTDIR=$(DESTDIR) PREFIX=$(PREFIX)

uninstall :
	make -C $(BUILDLOCATION) uninstall

# install :
# 	# install faust itself
# 	mkdir -p $(prefix)/bin/
# 	mkdir -p $(prefix)/lib/
# 	mkdir -p $(prefix)/lib/faust
# 	mkdir -p $(prefix)/include/
# 	mkdir -p $(prefix)/include/faust/
# 	mkdir -p $(prefix)/include/faust/osc/
# 	mkdir -p $(prefix)/include/faust/dsp/
# 	mkdir -p $(prefix)/share/faust
# 	([ -e $(BINLOCATION)/faust ] && install $(BINLOCATION)/faust $(prefix)/bin/)  || echo faust not available
# 	([ -e $(LIBLOCATION)/libfaust.$(LIB_EXT) ] && install $(LIBLOCATION)/libfaust.$(LIB_EXT) $(prefix)/lib/) || echo libfaust.$(LIB_EXT) not available
# 	([ -e $(LIBLOCATION)/libfaust.a ] && install $(LIBLOCATION)/libfaust.a $(prefix)/lib/) || echo libfaust.a not available
# 	cp compiler/generator/libfaust.h  $(prefix)/include/faust/dsp/
# 	cp compiler/generator/libfaust-c.h  $(prefix)/include/faust/dsp/
# 	cp compiler/generator/wasm/wasm-dsp.h  $(prefix)/include/faust/dsp/
# 	([ -e compiler/scheduler.ll ] && chmod gou+r compiler/scheduler.ll) || echo scheduler.ll not available
# 	([ -e compiler/scheduler.ll ] && cp compiler/scheduler.ll $(prefix)/lib/faust) || echo scheduler.ll not available
#
# 	# install architecture and faust library files
# 	cp architecture/*.c $(prefix)/share/faust/
# 	cp architecture/*.rs $(prefix)/share/faust/
# 	cp architecture/*.cpp $(prefix)/share/faust/
# 	cp architecture/*.java $(prefix)/share/faust/
# 	cp architecture/*.js $(prefix)/share/faust/
# 	cp libraries/old/*.lib $(prefix)/share/faust/
# 	cp libraries/*.lib $(prefix)/share/faust/
#
# 	# This is needed by faust2lv2 -gui / lv2ui.cpp.
# 	cp architecture/lv2qtgui.h $(prefix)/share/faust/
#
# 	# This is needed by faust2faustvst -gui / faustvst.cpp.
# 	cp architecture/faustvstqt.h $(prefix)/share/faust/
#
# 	# install iOS
# 	rm -rf $(prefix)/share/faust/iOS
# 	cp -r architecture/iOS $(prefix)/share/faust/
# 	cp -r architecture/osclib $(prefix)/share/faust
# 	# remove object files and libraries in the copied osclib folder
# 	$(MAKE) -C $(prefix)/share/faust/osclib clean
# 	rm -rf $(prefix)/share/faust/iOS/DerivedData/
# 	cp architecture/ios-libsndfile.a $(prefix)/lib/faust
#
# 	# install smartKeyboard
# 	rm -rf $(prefix)/share/faust/smartKeyboard
# 	cp -r architecture/smartKeyboard $(prefix)/share/faust/
#
# 	# install Juce
# 	rm -rf $(prefix)/share/faust/juce
# 	cp -r architecture/juce $(prefix)/share/faust/
#
# 	# install AU
# 	rm -rf $(prefix)/share/faust/AU/
# 	cp -r architecture/AU $(prefix)/share/faust/
#
# 	# install Android
# 	rm -rf $(prefix)/share/faust/android
# 	cp -r architecture/android $(prefix)/share/faust/
#
# 	# install APIs
# 	rm -rf $(prefix)/share/faust/api/
# 	cp -r architecture/api $(prefix)/share/faust/
#
# 	# install nodejs
# 	rm -rf $(prefix)/share/faust/nodejs/
# 	cp -r architecture/nodejs $(prefix)/share/faust/
#
# 	# install Max/MSP
# 	rm -rf $(prefix)/share/faust/max-msp/
# 	cp -r architecture/max-msp $(prefix)/share/faust/
#
# 	#install unity
# 	rm -rf $(prefix)/share/faust/unity
# 	cp -r architecture/unity $(prefix)/share/faust/
#
# 	# install math documentation files
# 	cp architecture/mathdoctexts-*.txt $(prefix)/share/faust/
# 	cp architecture/latexheader.tex $(prefix)/share/faust/
#
# 	# install additional binary libraries (osc, http,...)
# 	([ -e architecture/httpdlib/libHTTPDFaust.a ] && cp architecture/httpdlib/libHTTPDFaust.a $(prefix)/lib/) || echo libHTTPDFaust.a not available
# 	([ -e architecture/httpdlib/libHTTPDFaust.$(LIB_EXT) ] && cp architecture/httpdlib/libHTTPDFaust.$(LIB_EXT) $(prefix)/lib/) || echo libHTTPDFaust.$(LIB_EXT) not available
#
# 	([ -e architecture/osclib/libOSCFaust.a ] && cp architecture/osclib/libOSCFaust.a $(prefix)/lib/) || echo libOSCFaust.a not available
# 	([ -e architecture/osclib/libOSCFaust.$(LIB_EXT) ] && cp -a architecture/osclib/libOSCFaust*.$(LIB_EXT)* $(prefix)/lib/) || echo libOSCFaust.$(LIB_EXT) not available
#
# 	cp -r architecture/httpdlib/html/js $(prefix)/share/faust/js
# 	([ -e architecture/httpdlib/src/hexa/stylesheet ] && cp architecture/httpdlib/src/hexa/stylesheet $(prefix)/share/faust/js/stylesheet.js) || echo stylesheet not available
# 	([ -e architecture/httpdlib/src/hexa/jsscripts ] && cp architecture/httpdlib/src/hexa/jsscripts $(prefix)/share/faust/js/jsscripts.js) || echo jsscripts not available
#
# 	# install includes files for architectures
# 	cp -r architecture/faust $(prefix)/include/
#
# 	# install additional includes files for binary libraries  (osc, http,...)
# 	cp architecture/osclib/faust/faust/OSCControler.h $(prefix)/include/faust/gui/
# 	cp architecture/osclib/faust/faust/osc/*.h $(prefix)/include/faust/osc/
# 	cp architecture/httpdlib/src/include/*.h $(prefix)/include/faust/gui/
#
# 	# install faust2xxx tools
# 	make -C tools/faust2appls install
#
# 	# install sound converter
# 	[ -e tools/sound2faust/sound2faust ] && $(MAKE) -C tools/sound2faust install || echo sound2faust not compiled
#
# 	# install faustremote
# 	([ -e embedded/faustremote/libfaustremote.a ] &&  install embedded/faustremote/libfaustremote.a  $(prefix)/lib/) || echo remote not compiled
# 	cp embedded/faustremote/remote-dsp.h  $(prefix)/include/faust/dsp/
#
# 	# install webaudio
# 	cp -r architecture/webaudio $(prefix)/share/faust/
#
# 	# install Max/MSP
# 	cp -r architecture/max-msp $(prefix)/share/faust/
#
# 	# install benchmark tools
# 	rm -rf $(prefix)/share/faust/iOS-bench
# 	cp -r tools/benchmark/iOS-bench $(prefix)/share/faust/
# 	cp tools/benchmark/faustbench $(prefix)/bin/
# 	cp tools/benchmark/faustbench.cpp $(prefix)/share/faust/
# 	([ -e tools/benchmark/faustbench-llvm ]) && install tools/benchmark/faustbench $(prefix)/bin/ || echo faustbench-llvm not found
# 	([ -e tools/benchmark/faustbench-llvm-interp ]) && install tools/benchmark/faustbench-llvm $(prefix)/bin/ || echo faustbench-llvm-interp not found
#
# 	# install Faust man file
# 	([ -e faust.1 ]) && (install -d $(prefix)/share/man/man1/; install faust.1 $(prefix)/share/man/man1) || echo faust.1 not found


# install benchmark tools
devinstall:
	rm -rf $(prefix)/share/faust/iOS-bench
	cp -r tools/benchmark/iOS-bench $(prefix)/share/faust/
	cp tools/benchmark/faustbench $(prefix)/bin/
	cp tools/benchmark/faustbench.cpp $(prefix)/share/faust/
	([ -e tools/benchmark/faustbench-llvm ]) && install tools/benchmark/faustbench $(prefix)/bin/ || echo faustbench-llvm not found
	([ -e tools/benchmark/faustbench-llvm-interp ]) && install tools/benchmark/faustbench-llvm $(prefix)/bin/ || echo faustbench-llvm-interp not found


# uninstall :
# 	rm -f $(addprefix $(prefix)/lib/, libfaust.a libfaust.$(LIB_EXT) libHTTPDFaust.a libHTTPDFaust.$(LIB_EXT) libOSCFaust.a libOSCFaust*.$(LIB_EXT)* libfaustremote.a)
# 	rm -rf $(prefix)/share/faust/
# 	rm -rf $(prefix)/include/faust/
# 	rm -f $(prefix)/bin/faust$(EXE)
# 	rm -f $(prefix)/bin/RemoteServer$(EXE)
# 	make -C tools/faust2appls uninstall
# 	rm -f $(prefix)/bin/sound2faust$(EXE)
# 	rm -f $(prefix)/bin/faustbench
# 	rm -f $(prefix)/share/man/man1/faust.1
# 	rm -f $(prefix)/lib/faust/ios-libsndfile.a

# make a faust distribution tarball
dist = faust-$(version)
submodules = libraries
dist :
	rm -rf $(dist)
# Make sure that the submodules are initialized.
	git submodule update --init
# Grab the main source.
	git archive --format=tar.gz --prefix=$(dist)/ HEAD | tar xfz -
# Grab the submodules.
	for x in $(submodules); do (cd $(dist) && rm -rf $$x && git -C ../$$x archive --format=tar.gz --prefix=$$x/ HEAD | tar xfz -); done
# Create the source tarball.
	tar cfz $(dist).tar.gz $(dist)
	rm -rf $(dist)

# this does the same, but uses the $(debversion) instead (see below) which
# includes the actual git revision number and hash (useful for git snapshots)
dist-snapshot :
	$(MAKE) dist dist=faust-$(debversion)

log :
	git log --oneline --date-order --reverse --after={2014-05-19} master >log-$(version)

# Make Debian packages. This builds a package from the current HEAD in a
# subdirectory named $(debdist). It also creates the source archive that goes
# along with it. All files will be created in the toplevel Faust source
# directory.

# To make this work, you need to have the Debian package toolchain (debuild
# and friends) installed. Also make sure you have your DEBEMAIL and
# DEBFULLNAME environment variables set up as explained in the debchange(1)
# manual page. These are needed to create changelog entries and in order to
# sign the Debian packages created with 'make deb' and 'make debsrc'.

# The typical workflow is as follows:

# 1. Run 'make debchange' once to create a new debian/changelog entry. You
# *must* do this once so that debuild knows about the proper version number of
# the package.

# 2. Run 'make deb' to build a signed binary package. Or 'make deb-us' for an
# unsigned one.

# If you only need the binary package for local deployment then you're done.
# Otherwise proceed to step 3.

# 3. Run 'make debsrc' to create a signed Debian source package which can be
# uploaded, e.g, to Launchpad using 'dput'. Or 'make debsrc-us' for an
# unsigned package.

# 4. Run 'make debclean' to get rid of any files that were created in steps 2
# and 3.

# The Debian version gets derived from the package version $(version) as well
# as the date and serial number of the last commit.
debversion = $(version)+git$(shell git log -1 --format=%cd --date=short 2>/dev/null | sed -e 's/-//g')+$(shell git rev-list --count HEAD 2>/dev/null)
# Debian revision number of the package.
debrevision = 1
# Source tarball and folder.
debsrc = faust_$(debversion).orig.tar.gz
debdist = faust-$(debversion)

# This is used for automatically generated debian/changelog entries (cf. 'make
# debchange'). Adjust as needed.
debmsg = "Build from latest upstream source."
debprio = "low"

.PHONY: debversion debchange debclean deb debsrc deb-us debsrc-us

debversion:
	@echo $(debversion)

debchange:
	dch -u $(debprio) -v $(debversion)-$(debrevision) $(debmsg) && dch -r ""

debclean:
	rm -rf $(debdist)
	rm -f faust_$(version)+git* faust-dbgsym_$(version)+git*

deb: $(debsrc)
	rm -rf $(debdist)
	tar xfz $(debsrc)
# Here we just copy debian/ from the working copy since it might have changes
# that haven't been committed yet.
	cd $(debdist) && cp -R ../debian . && debuild $(DEBUILD_FLAGS)
	rm -rf $(debdist)

debsrc:
	$(MAKE) deb DEBUILD_FLAGS=-S

deb-us:
	$(MAKE) deb DEBUILD_FLAGS="-us -uc"

debsrc-us:
	$(MAKE) deb DEBUILD_FLAGS="-S -us -uc"

$(debsrc) :
	rm -rf $(debdist)
# Make sure that the submodules are initialized.
	git submodule update --init
# Grab the main source.
	git archive --format=tar.gz --prefix=$(debdist)/ HEAD | tar xfz -
# Grab the submodules.
	for x in $(submodules); do (cd $(debdist) && rm -rf $$x && git -C ../$$x archive --format=tar.gz --prefix=$$x/ HEAD | tar xfz -); done
# Create the source tarball.
	tar cfz $(debsrc) $(debdist)
	rm -rf $(debdist)

# DO NOT DELETE
BGFLAGS= --disable-name-namespacing --enable-cxx-namespaces --conservative-inline-namespaces --builtins --enable-function-attribute-detection --generate-block --generate-inline-functions --impl-debug --impl-partialeq --with-derive-default --with-derive-eq --with-derive-hash --with-derive-ord --default-enum-style rust
CFLAGS= -DUSE_PTHREAD -I/usr/lib/gcc/x86_64-pc-linux-gnu/8.2.1/include -I/usr/lib/gcc/x86_64-pc-linux-gnu/8.2.1/include -std=c11
CXXFLAGS= -DUSE_PTHREAD -I/usr/lib/gcc/x86_64-pc-linux-gnu/8.2.1/include -I/usr/lib/gcc/x86_64-pc-linux-gnu/8.2.1/include -std=c++17
# Generate Rust bindings
bind:
	# bindgen $(BGFLAGS) -o src/include/misc.rs src/include/misc.hh -- $(CXXFLAGS)
	# bindgen $(BGFLAGS) -o src/include/sound-file.rs src/include/sound-file.hh -- $(CXXFLAGS)
	# bindgen $(BGFLAGS) -o src/include/audio/alsa-dsp.rs src/include/audio/alsa-dsp.hh -- $(CXXFLAGS)
	# bindgen $(BGFLAGS) -o src/include/audio/audio.rs src/include/audio/audio.hh -- $(CXXFLAGS)
	# bindgen $(BGFLAGS) -o src/include/audio/channels.rs src/include/audio/channels.hh -- $(CXXFLAGS)
	# bindgen $(BGFLAGS) -o src/include/audio/dummy-audio.rs src/include/audio/dummy-audio.hh -- $(CXXFLAGS)
	# bindgen $(BGFLAGS) -o src/include/audio/jack-dsp.rs src/include/audio/jack-dsp.hh -- $(CXXFLAGS)
	# bindgen $(BGFLAGS) -o src/include/audio/juce-dsp.rs src/include/audio/juce-dsp.hh -- $(CXXFLAGS)
	# bindgen $(BGFLAGS) -o src/include/audio/netjack-dsp.rs src/include/audio/netjack-dsp.hh -- $(CXXFLAGS)
	# bindgen $(BGFLAGS) -o src/include/audio/ofaudio-dsp.rs src/include/audio/ofaudio-dsp.hh -- $(CXXFLAGS)
	# bindgen $(BGFLAGS) -o src/include/audio/osc-dsp.rs src/include/audio/osc-dsp.hh -- $(CXXFLAGS)
	# bindgen $(BGFLAGS) -o src/include/audio/portaudio-dsp.rs src/include/audio/portaudio-dsp.hh -- $(CXXFLAGS)
	# bindgen $(BGFLAGS) -o src/include/audio/rtaudio-dsp.rs src/include/audio/rtaudio-dsp.hh -- $(CXXFLAGS)
	# bindgen $(BGFLAGS) -o src/include/audio/samAudio.rs src/include/audio/samAudio.hh -- $(CXXFLAGS)
	# bindgen $(BGFLAGS) -o src/include/dsp/dsp-adapter.rs src/include/dsp/dsp-adapter.hh -- $(CXXFLAGS)
	# bindgen $(BGFLAGS) -o src/include/dsp/dsp-bench.rs src/include/dsp/dsp-bench.hh -- $(CXXFLAGS)
	# bindgen $(BGFLAGS) -o src/include/dsp/dsp-checker.rs src/include/dsp/dsp-checker.hh -- $(CXXFLAGS)
	# bindgen $(BGFLAGS) -o src/include/dsp/dsp-combiner.rs src/include/dsp/dsp-combiner.hh -- $(CXXFLAGS)
	# bindgen $(BGFLAGS) -o src/include/dsp/dsp-optimizer.rs src/include/dsp/dsp-optimizer.hh -- $(CXXFLAGS)
	# bindgen $(BGFLAGS) -o src/include/dsp/dsp-tools.rs src/include/dsp/dsp-tools.hh -- $(CXXFLAGS)
	# bindgen $(BGFLAGS) -o src/include/dsp/dsp.rs src/include/dsp/dsp.hh -- $(CXXFLAGS)
	# bindgen $(BGFLAGS) -o src/include/dsp/faust-dynamic-engine.rs src/include/dsp/faust-dynamic-engine.hh -- $(CXXFLAGS)
	# bindgen $(BGFLAGS) -o src/include/dsp/faust-engine.rs src/include/dsp/faust-engine.hh -- $(CXXFLAGS)
	# bindgen $(BGFLAGS) -o src/include/dsp/faust-poly-engine.rs src/include/dsp/faust-poly-engine.hh -- $(CXXFLAGS)
	# bindgen $(BGFLAGS) -o src/include/dsp/interpreter-dsp.rs src/include/dsp/interpreter-dsp.hh -- $(CXXFLAGS)
	# bindgen $(BGFLAGS) -o src/include/dsp/interpreter-machine-dsp.rs src/include/dsp/interpreter-machine-dsp.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/dsp/libfaust-c.rs src/include/dsp/libfaust-c.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/dsp/libfaust.rs src/include/dsp/libfaust.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/dsp/llvm-c-dsp.rs src/include/dsp/llvm-c-dsp.h -- $(CFLAGS)
	bindgen $(BGFLAGS) -o src/include/dsp/llvm-dsp.rs src/include/dsp/llvm-dsp.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/dsp/llvm-machine-dsp.rs src/include/dsp/llvm-machine-dsp.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/dsp/poly-dsp.rs src/include/dsp/poly-dsp.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/dsp/poly-interpreter-dsp.rs src/include/dsp/poly-interpreter-dsp.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/dsp/poly-llvm-dsp.rs src/include/dsp/poly-llvm-dsp.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/dsp/poly-wasm-dsp.rs src/include/dsp/poly-wasm-dsp.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/dsp/proxy-dsp.rs src/include/dsp/proxy-dsp.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/dsp/sound-player.rs src/include/dsp/sound-player.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/dsp/timed-dsp.rs src/include/dsp/timed-dsp.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/APIUI.rs src/include/gui/APIUI.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/BelaOSCUI.rs src/include/gui/BelaOSCUI.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/CGlue.rs src/include/gui/CGlue.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/console.rs src/include/gui/console.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/ControlUI.rs src/include/gui/ControlUI.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/DecoratorUI.rs src/include/gui/DecoratorUI.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/faustgtk.rs src/include/gui/faustgtk.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/faustqt.rs src/include/gui/faustqt.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/FUI.rs src/include/gui/FUI.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/GUI.rs src/include/gui/GUI.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/HTTPDControler.rs src/include/gui/HTTPDControler.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/httpdUI.rs src/include/gui/httpdUI.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/jsonfaustui.rs src/include/gui/jsonfaustui.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/JSONUI.rs src/include/gui/JSONUI.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/JSONUIDecoder.rs src/include/gui/JSONUIDecoder.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/JuceGUI.rs src/include/gui/JuceGUI.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/JuceOSCUI.rs src/include/gui/JuceOSCUI.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/JuceParameterUI.rs src/include/gui/JuceParameterUI.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/JuceReader.rs src/include/gui/JuceReader.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/JuceStateUI.rs src/include/gui/JuceStateUI.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/LibsndfileReader.rs src/include/gui/LibsndfileReader.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/MapUI.rs src/include/gui/MapUI.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/MemoryReader.rs src/include/gui/MemoryReader.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/meta.rs src/include/gui/meta.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/MetaDataUI.rs src/include/gui/MetaDataUI.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/MidiUI.rs src/include/gui/MidiUI.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/OCVUI.rs src/include/gui/OCVUI.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/OSCControler.rs src/include/gui/OSCControler.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/OSCIO.rs src/include/gui/OSCIO.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/OSCUI.rs src/include/gui/OSCUI.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/PathBuilder.rs src/include/gui/PathBuilder.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/PresetUI.rs src/include/gui/PresetUI.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/PrintUI.rs src/include/gui/PrintUI.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/qrcodegen.rs src/include/gui/qrcodegen.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/ring-buffer.rs src/include/gui/ring-buffer.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/RosCI.rs src/include/gui/RosCI.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/RosUI.rs src/include/gui/RosUI.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/SimpleParser.rs src/include/gui/SimpleParser.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/Soundfile.rs src/include/gui/Soundfile.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/SoundUI.rs src/include/gui/SoundUI.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/UI.rs src/include/gui/UI.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/gui/ValueConverter.rs src/include/gui/ValueConverter.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/midi/bela-midi.rs src/include/midi/bela-midi.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/midi/jack-midi.rs src/include/midi/jack-midi.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/midi/juce-midi.rs src/include/midi/juce-midi.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/midi/midi.rs src/include/midi/midi.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/midi/rt-midi.rs src/include/midi/rt-midi.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/midi/RtMidi.rs src/include/midi/RtMidi.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/osc/FaustFactory.rs src/include/osc/FaustFactory.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/osc/FaustNode.rs src/include/osc/FaustNode.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/osc/Message.rs src/include/osc/Message.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/osc/MessageDriven.rs src/include/osc/MessageDriven.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/osc/MessageProcessor.rs src/include/osc/MessageProcessor.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/osc/RootNode.rs src/include/osc/RootNode.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/osc/smartpointer.rs src/include/osc/smartpointer.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/vst/faust.rs src/include/vst/faust.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/vst/voice.rs src/include/vst/voice.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/include/vst/vstui.rs src/include/vst/vstui.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/architecture/faustvstqt.rs src/architecture/faustvstqt.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/architecture/lv2qtgui.rs src/architecture/lv2qtgui.hh -- $(CXXFLAGS)
	bindgen $(BGFLAGS) -o src/architecture/thread.rs src/architecture/thread.hh -- $(CXXFLAGS)