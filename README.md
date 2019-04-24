# Faust - Programming Language for Audio Applications and Plugins

## Grame, Centre National de Creation Musicale: <http://www.grame.fr>

master : [![Build Status](https://travis-ci.org/grame-cncm/faust.svg?branch=master)](https://travis-ci.org/grame-cncm/faust)
master-dev : [![Build Status](https://travis-ci.org/grame-cncm/faust.svg?branch=master-dev)](https://travis-ci.org/grame-cncm/faust)

## Introduction

Faust (Functional Audio Stream) is a functional programming language specifically designed for real-time signal processing and synthesis. A distinctive characteristic of Faust is to be fully compiled.

The Faust compiler translates DSP specifications into very efficient code for various languages (C++, C, JAVA, JavaScript, ASM JavaScript, LLVM IR, WebAssembly etc.) working at sample level. It targets high-performance signal processing applications, libraries and audio plug-ins for a variety of audio platforms and standards. A same Faust specification can be used to easily generate various kinds of native standalone applications, iOS and Android apps, as well as Csound, LADSPA, Max/MSP, PD, Q, SuperCollider, VST, AU plugins, etc. (see the README in the `/architecture` folder for an exhaustive list).

While there are Faust contributors everywhere across the globe, Faust is mainly being developed at Grame, Centre National de Creation Musicale (<http://www.grame.fr>), its birthplace.

## This repo

`faustus` is a creative coding toolkit for the FAUST project written in Rust. As such it has been customized and refactored. Eventually faustus will be a part of [tgtracker](https://github.com/tonal-glyph/tgtracker).

## Overview of the Faust Distribution

This is an overview of the content of the top-level folders of the Faust distribution. Most of these folders contain their own README describing their content in more details.

	architecture/          : the architecture files currently supported
	benchmark/             : tools to measure the impact of various compiler options
	build/                 : build tools and scripts (cmake based)
	compiler/              : sources of the Faust compiler
	debian/                : files for Debian installation
	documentation/         : Faust developer's documentation
	examples/              : Faust programs examples organized by categories
	installer/             : various installers for Linux distribution
	libraries/             : DSP libraries
	syntax-highlighting/   : support for syntax highlighting for several editors
	tests/                 : various tests
	tools/                 : additional easy-to-use scripts (faust2...) to produce binaries and plugins
	windows/               : Windows related resources

### `faust2...` Scripts and Programs

The `faust2...` scripts and programs are command line tools allowing to compile Faust codes to any of the supported Faust targets ("architectures"). They are placed on your system during the Faust installation process. The fastest way to get an exhaustive list of all of them is to open a terminal window, type `faust2`, and then press the Tab key for auto-completion. For example, to compile a Faust code as a JACK application with a Qt interface, run:

	faust2jaqt yourCode.dsp

The most commonly used `faust2` scripts are:

    faust2alqt              : ALSA application with Qt UI
    faust2alsa              : ALSA application with GTK UI
    faust2alsaconsole       : ALSA command line program
    faust2android           : Android app
    faust2api               : API generator
    faust2asmjs             : asmjs WebAudio code
    faust2au                : Audio Unit plugin
    faust2bela              : BELA program
    faust2caqt              : CoreAudio application with Qt UI
    faust2caqtios           : iOS app with Qt UI
    faust2csound            : CSOUND Opcode
    faust2faustvst          : VST plug-in
    faust2graph             : svg graph
    faust2ios               : iOS app
    faust2jack              : JACK application with GTK UI
    faust2jackconsole       : JACK command line program
    faust2jaqt              : JACK application with Qt UI
    faust2ladspa            : LADSPA plug-in
    faust2lv2               : LV2 plug-in
    faust2mathdoc           : automatic pdf mathematical documentation
    faust2max6              : MaxMSP 6 (and later) external and patch
    faust2msp               : MaxMSP 5 external and patch
    faust2netjackconsole    : NetJack command line program
    faust2netjackqt         : NetJack application with Qt UI
    faust2octave            : Octave script
    faust2owl               : OWL Program
    faust2pdf               : pdf block diagram
    faust2plot              : command line program to debug DSP (sample plotting, etc.)
    faust2png               : png block diagram
    faust2puredata          : PureData external
    faust2ros               : ROS app
    faust2rosgtk            : ROS app with GTK UI
    faust2rpialsaconsole    : Raspberry Pi ALSA command line program
    faust2rpinetjackconsole : Raspberry Pi JACK command line program
    faust2sig               : SVG signal
    faust2supercollider     : SuperCollider external
    faust2svg               : SVG block diagram
    faust2webaudioasm       : WebAudio web HTML app

Obviously, the corresponding dependencies for each of them must be installed on your system for compilation to be successful. For example, if you use `faust2jaqt`, JACK and Qt libraries must be installed.

## Documentation and Resources

* `/documentation/faust-quick-reference.pdf` contains the most up-to-date documentation of Faust.
* `/documentation/library.pdf` contains the documentation of the Faust DSP libraries.
* The Faust website: <https://faust.grame.fr> contains useful resources around Faust.
* The [Faust online course](https://ccrma.stanford.edu/~rmichon/faustWorkshops/course2015/) or the [Faust Hero in 2 Hours tutorial](https://ccrma.stanford.edu/~rmichon/faustTutorials/#faust-hero-in-2-hours) might be good starting points for beginners.
* [Julius Smith's website](https://ccrma.stanford.edu/~jos) is an incredible resource on various topics around DSP and Faust.

## Acknowledgments

Many persons have been contributing to the Faust project by
providing code for the compiler, architecture files, libraries,
examples, documentation, scripts, bug reports, ideas, etc.

I would like to thank them and especially: Fons Adriaensen, Tiziano
Bole, Baktery Chanka, Thomas Charbonnel, Damien Cramet, Etienne
Gaudrin, Albert Graef, Stefan Kersten, Victor Lazzarini, Matthieu
Leberre, Mathieu Leroi, Kjetil Matheussen, Remy Muller, Sampo
Savolainen, Nicolas Scaringella, Stephen Sinclair, Travis Skare,
Julius Smith, as well as my colleagues at GRAME, in particular :
Dominique Fober, Stephane Letz and Karim Barkati, and from the
ASTREE project : Jerome Barthelemy (IRCAM), Alain Bonardi (IRCAM),
Raffaele Ciavarella (IRCAM), Pierre Jouvelot (Ecole des
Mines/ParisTech), Laurent Pottier (U. Saint-Etienne)

## Questions and suggestions

If you have questions suggestions and comments, or if you want to
contribute to the project, two mailing lists are available:
- [Development List](https://lists.sourceforge.net/lists/listinfo/faudiostream-devel)
- [Users List](https://lists.sourceforge.net/lists/listinfo/faudiostream-users)
- [Yann Orlarey](https://github.com/orlarey)

## License

The original FAUST project is licensed under GPL2. The Rust binding code is released under the same license. Any abstractions or coding toolkit code in Rust is dual licensed under Apache 2.0/MIT to best serve the Rust community.