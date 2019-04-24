# Install script for directory: /home/dark/proj/faust/build

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "0")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}/usr/local/bin/faust" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/usr/local/bin/faust")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}/usr/local/bin/faust"
         RPATH "")
  endif()
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/usr/local/bin/faust")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/usr/local/bin" TYPE EXECUTABLE FILES "/home/dark/proj/faust/build/bin/faust")
  if(EXISTS "$ENV{DESTDIR}/usr/local/bin/faust" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/usr/local/bin/faust")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}/usr/local/bin/faust")
    endif()
  endif()
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/usr/local/lib/libfaust.a")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/usr/local/lib" TYPE STATIC_LIBRARY FILES "/home/dark/proj/faust/build/lib/libfaust.a")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  foreach(file
      "$ENV{DESTDIR}/usr/local/lib/libfaust.so.2.14.3"
      "$ENV{DESTDIR}/usr/local/lib/libfaust.so.2"
      )
    if(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      file(RPATH_CHECK
           FILE "${file}"
           RPATH "")
    endif()
  endforeach()
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/usr/local/lib/libfaust.so.2.14.3;/usr/local/lib/libfaust.so.2")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/usr/local/lib" TYPE SHARED_LIBRARY FILES
    "/home/dark/proj/faust/build/lib/libfaust.so.2.14.3"
    "/home/dark/proj/faust/build/lib/libfaust.so.2"
    )
  foreach(file
      "$ENV{DESTDIR}/usr/local/lib/libfaust.so.2.14.3"
      "$ENV{DESTDIR}/usr/local/lib/libfaust.so.2"
      )
    if(EXISTS "${file}" AND
       NOT IS_SYMLINK "${file}")
      if(CMAKE_INSTALL_DO_STRIP)
        execute_process(COMMAND "/usr/bin/strip" "${file}")
      endif()
    endif()
  endforeach()
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}/usr/local/lib/libfaust.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/usr/local/lib/libfaust.so")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}/usr/local/lib/libfaust.so"
         RPATH "")
  endif()
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/usr/local/lib/libfaust.so")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/usr/local/lib" TYPE SHARED_LIBRARY FILES "/home/dark/proj/faust/build/lib/libfaust.so")
  if(EXISTS "$ENV{DESTDIR}/usr/local/lib/libfaust.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/usr/local/lib/libfaust.so")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}/usr/local/lib/libfaust.so")
    endif()
  endif()
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/usr/local/include/faust/au;/usr/local/include/faust/audio;/usr/local/include/faust/dsp;/usr/local/include/faust/gui;/usr/local/include/faust/midi;/usr/local/include/faust/unity;/usr/local/include/faust/vst")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/usr/local/include/faust" TYPE DIRECTORY PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ DIR_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE FILES
    "/home/dark/proj/faust/architecture/faust/au"
    "/home/dark/proj/faust/architecture/faust/audio"
    "/home/dark/proj/faust/architecture/faust/dsp"
    "/home/dark/proj/faust/architecture/faust/gui"
    "/home/dark/proj/faust/architecture/faust/midi"
    "/home/dark/proj/faust/architecture/faust/unity"
    "/home/dark/proj/faust/architecture/faust/vst"
    REGEX "/\\.DS\\_Store$" EXCLUDE REGEX "/[^/]*\\.o$" EXCLUDE)
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/usr/local/include/faust/misc.h;/usr/local/include/faust/sound-file.h")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/usr/local/include/faust" TYPE FILE PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ FILES
    "/home/dark/proj/faust/architecture/faust/misc.h"
    "/home/dark/proj/faust/architecture/faust/sound-file.h"
    )
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/usr/local/include/faust/dsp/libfaust.h;/usr/local/include/faust/dsp/libfaust-c.h")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/usr/local/include/faust/dsp" TYPE FILE PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ FILES
    "/home/dark/proj/faust/compiler/generator/libfaust.h"
    "/home/dark/proj/faust/compiler/generator/libfaust-c.h"
    )
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/usr/local/include/faust/gui/HTTPDControler.h")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/usr/local/include/faust/gui" TYPE FILE PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ FILES "/home/dark/proj/faust/architecture/httpdlib/src/include/HTTPDControler.h")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/usr/local/bin/encoderunitypackage;/usr/local/bin/faust2alqt;/usr/local/bin/faust2alsa;/usr/local/bin/faust2alsaconsole;/usr/local/bin/faust2android;/usr/local/bin/faust2androidunity;/usr/local/bin/faust2api;/usr/local/bin/faust2asmjs;/usr/local/bin/faust2atomsnippets;/usr/local/bin/faust2au;/usr/local/bin/faust2bela;/usr/local/bin/faust2caqt;/usr/local/bin/faust2caqtios;/usr/local/bin/faust2csound;/usr/local/bin/faust2csvplot;/usr/local/bin/faust2dssi;/usr/local/bin/faust2dummy;/usr/local/bin/faust2dummymem;/usr/local/bin/faust2eps;/usr/local/bin/faust2faustvst;/usr/local/bin/faust2firefox;/usr/local/bin/faust2gen;/usr/local/bin/faust2graph;/usr/local/bin/faust2graphviewer;/usr/local/bin/faust2ios;/usr/local/bin/faust2jack;/usr/local/bin/faust2jackconsole;/usr/local/bin/faust2jackinternal;/usr/local/bin/faust2jackrust;/usr/local/bin/faust2jackserver;/usr/local/bin/faust2jaqt;/usr/local/bin/faust2jaqtchain;/usr/local/bin/faust2javaswing;/usr/local/bin/faust2juce;/usr/local/bin/faust2ladspa;/usr/local/bin/faust2linuxunity;/usr/local/bin/faust2lv2;/usr/local/bin/faust2mathdoc;/usr/local/bin/faust2mathviewer;/usr/local/bin/faust2max6;/usr/local/bin/faust2md;/usr/local/bin/faust2msp;/usr/local/bin/faust2netjackconsole;/usr/local/bin/faust2netjackqt;/usr/local/bin/faust2nodejs;/usr/local/bin/faust2octave;/usr/local/bin/faust2osxiosunity;/usr/local/bin/faust2owl;/usr/local/bin/faust2paqt;/usr/local/bin/faust2pdf;/usr/local/bin/faust2plot;/usr/local/bin/faust2png;/usr/local/bin/faust2portaudiorust;/usr/local/bin/faust2pure;/usr/local/bin/faust2puredata;/usr/local/bin/faust2raqt;/usr/local/bin/faust2ros;/usr/local/bin/faust2rosgtk;/usr/local/bin/faust2rpialsaconsole;/usr/local/bin/faust2rpinetjackconsole;/usr/local/bin/faust2sam;/usr/local/bin/faust2sig;/usr/local/bin/faust2sigviewer;/usr/local/bin/faust2smartkeyb;/usr/local/bin/faust2sndfile;/usr/local/bin/faust2supercollider;/usr/local/bin/faust2svg;/usr/local/bin/faust2unity;/usr/local/bin/faust2vst;/usr/local/bin/faust2vsti;/usr/local/bin/faust2w32max6;/usr/local/bin/faust2w32msp;/usr/local/bin/faust2w32puredata;/usr/local/bin/faust2w32vst;/usr/local/bin/faust2w64max6;/usr/local/bin/faust2wasm;/usr/local/bin/faust2webaudio;/usr/local/bin/faust2webaudioasm;/usr/local/bin/faust2webaudiowasm;/usr/local/bin/faust2webaudiowast;/usr/local/bin/faust2winunity;/usr/local/bin/faust2sc")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/usr/local/bin" TYPE FILE PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_EXECUTE WORLD_READ FILES
    "/home/dark/proj/faust/tools/faust2appls/encoderunitypackage"
    "/home/dark/proj/faust/tools/faust2appls/faust2alqt"
    "/home/dark/proj/faust/tools/faust2appls/faust2alsa"
    "/home/dark/proj/faust/tools/faust2appls/faust2alsaconsole"
    "/home/dark/proj/faust/tools/faust2appls/faust2android"
    "/home/dark/proj/faust/tools/faust2appls/faust2androidunity"
    "/home/dark/proj/faust/tools/faust2appls/faust2api"
    "/home/dark/proj/faust/tools/faust2appls/faust2asmjs"
    "/home/dark/proj/faust/tools/faust2appls/faust2atomsnippets"
    "/home/dark/proj/faust/tools/faust2appls/faust2au"
    "/home/dark/proj/faust/tools/faust2appls/faust2bela"
    "/home/dark/proj/faust/tools/faust2appls/faust2caqt"
    "/home/dark/proj/faust/tools/faust2appls/faust2caqtios"
    "/home/dark/proj/faust/tools/faust2appls/faust2csound"
    "/home/dark/proj/faust/tools/faust2appls/faust2csvplot"
    "/home/dark/proj/faust/tools/faust2appls/faust2dssi"
    "/home/dark/proj/faust/tools/faust2appls/faust2dummy"
    "/home/dark/proj/faust/tools/faust2appls/faust2dummymem"
    "/home/dark/proj/faust/tools/faust2appls/faust2eps"
    "/home/dark/proj/faust/tools/faust2appls/faust2faustvst"
    "/home/dark/proj/faust/tools/faust2appls/faust2firefox"
    "/home/dark/proj/faust/tools/faust2appls/faust2gen"
    "/home/dark/proj/faust/tools/faust2appls/faust2graph"
    "/home/dark/proj/faust/tools/faust2appls/faust2graphviewer"
    "/home/dark/proj/faust/tools/faust2appls/faust2ios"
    "/home/dark/proj/faust/tools/faust2appls/faust2jack"
    "/home/dark/proj/faust/tools/faust2appls/faust2jackconsole"
    "/home/dark/proj/faust/tools/faust2appls/faust2jackinternal"
    "/home/dark/proj/faust/tools/faust2appls/faust2jackrust"
    "/home/dark/proj/faust/tools/faust2appls/faust2jackserver"
    "/home/dark/proj/faust/tools/faust2appls/faust2jaqt"
    "/home/dark/proj/faust/tools/faust2appls/faust2jaqtchain"
    "/home/dark/proj/faust/tools/faust2appls/faust2javaswing"
    "/home/dark/proj/faust/tools/faust2appls/faust2juce"
    "/home/dark/proj/faust/tools/faust2appls/faust2ladspa"
    "/home/dark/proj/faust/tools/faust2appls/faust2linuxunity"
    "/home/dark/proj/faust/tools/faust2appls/faust2lv2"
    "/home/dark/proj/faust/tools/faust2appls/faust2mathdoc"
    "/home/dark/proj/faust/tools/faust2appls/faust2mathviewer"
    "/home/dark/proj/faust/tools/faust2appls/faust2max6"
    "/home/dark/proj/faust/tools/faust2appls/faust2md"
    "/home/dark/proj/faust/tools/faust2appls/faust2msp"
    "/home/dark/proj/faust/tools/faust2appls/faust2netjackconsole"
    "/home/dark/proj/faust/tools/faust2appls/faust2netjackqt"
    "/home/dark/proj/faust/tools/faust2appls/faust2nodejs"
    "/home/dark/proj/faust/tools/faust2appls/faust2octave"
    "/home/dark/proj/faust/tools/faust2appls/faust2osxiosunity"
    "/home/dark/proj/faust/tools/faust2appls/faust2owl"
    "/home/dark/proj/faust/tools/faust2appls/faust2paqt"
    "/home/dark/proj/faust/tools/faust2appls/faust2pdf"
    "/home/dark/proj/faust/tools/faust2appls/faust2plot"
    "/home/dark/proj/faust/tools/faust2appls/faust2png"
    "/home/dark/proj/faust/tools/faust2appls/faust2portaudiorust"
    "/home/dark/proj/faust/tools/faust2appls/faust2pure"
    "/home/dark/proj/faust/tools/faust2appls/faust2puredata"
    "/home/dark/proj/faust/tools/faust2appls/faust2raqt"
    "/home/dark/proj/faust/tools/faust2appls/faust2ros"
    "/home/dark/proj/faust/tools/faust2appls/faust2rosgtk"
    "/home/dark/proj/faust/tools/faust2appls/faust2rpialsaconsole"
    "/home/dark/proj/faust/tools/faust2appls/faust2rpinetjackconsole"
    "/home/dark/proj/faust/tools/faust2appls/faust2sam"
    "/home/dark/proj/faust/tools/faust2appls/faust2sig"
    "/home/dark/proj/faust/tools/faust2appls/faust2sigviewer"
    "/home/dark/proj/faust/tools/faust2appls/faust2smartkeyb"
    "/home/dark/proj/faust/tools/faust2appls/faust2sndfile"
    "/home/dark/proj/faust/tools/faust2appls/faust2supercollider"
    "/home/dark/proj/faust/tools/faust2appls/faust2svg"
    "/home/dark/proj/faust/tools/faust2appls/faust2unity"
    "/home/dark/proj/faust/tools/faust2appls/faust2vst"
    "/home/dark/proj/faust/tools/faust2appls/faust2vsti"
    "/home/dark/proj/faust/tools/faust2appls/faust2w32max6"
    "/home/dark/proj/faust/tools/faust2appls/faust2w32msp"
    "/home/dark/proj/faust/tools/faust2appls/faust2w32puredata"
    "/home/dark/proj/faust/tools/faust2appls/faust2w32vst"
    "/home/dark/proj/faust/tools/faust2appls/faust2w64max6"
    "/home/dark/proj/faust/tools/faust2appls/faust2wasm"
    "/home/dark/proj/faust/tools/faust2appls/faust2webaudio"
    "/home/dark/proj/faust/tools/faust2appls/faust2webaudioasm"
    "/home/dark/proj/faust/tools/faust2appls/faust2webaudiowasm"
    "/home/dark/proj/faust/tools/faust2appls/faust2webaudiowast"
    "/home/dark/proj/faust/tools/faust2appls/faust2winunity"
    "/home/dark/proj/faust/tools/faust2sc-1.0.0/faust2sc"
    )
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/usr/local/bin/faustoptflags;/usr/local/bin/faustpath")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/usr/local/bin" TYPE FILE PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_EXECUTE WORLD_READ FILES
    "/home/dark/proj/faust/tools/faust2appls/faustoptflags"
    "/home/dark/proj/faust/tools/faust2appls/faustpath"
    )
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/usr/local/bin/sound2faust;/usr/local/bin/sound2file;/usr/local/bin/sound2reader")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/usr/local/bin" TYPE FILE OPTIONAL PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_EXECUTE WORLD_READ FILES
    "/home/dark/proj/faust/tools/sound2faust/sound2faust"
    "/home/dark/proj/faust/tools/sound2faust/sound2file"
    "/home/dark/proj/faust/tools/sound2faust/sound2reader"
    )
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/usr/local/share/man/man1/faust.1")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/usr/local/share/man/man1" TYPE FILE PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ FILES "/home/dark/proj/faust/documentation/man/man1/faust.1")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/usr/local/share/faust/js/jsscripts.js")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/usr/local/share/faust/js" TYPE FILE PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ RENAME "jsscripts.js" FILES "/home/dark/proj/faust/architecture/httpdlib/src/hexa/jsscripts")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/usr/local/share/faust/js/stylesheet.js")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/usr/local/share/faust/js" TYPE FILE PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ RENAME "stylesheet.js" FILES "/home/dark/proj/faust/architecture/httpdlib/src/hexa/stylesheet")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/usr/local/share/faust/all.lib;/usr/local/share/faust/analyzers.lib;/usr/local/share/faust/basics.lib;/usr/local/share/faust/compressors.lib;/usr/local/share/faust/delays.lib;/usr/local/share/faust/demos.lib;/usr/local/share/faust/dx7.lib;/usr/local/share/faust/envelopes.lib;/usr/local/share/faust/filters.lib;/usr/local/share/faust/hoa.lib;/usr/local/share/faust/instruments.lib;/usr/local/share/faust/maths.lib;/usr/local/share/faust/maxmsp.lib;/usr/local/share/faust/mi.lib;/usr/local/share/faust/misceffects.lib;/usr/local/share/faust/noises.lib;/usr/local/share/faust/effect.lib;/usr/local/share/faust/filter.lib;/usr/local/share/faust/math.lib;/usr/local/share/faust/music.lib;/usr/local/share/faust/oscillator.lib;/usr/local/share/faust/oscillators.lib;/usr/local/share/faust/phaflangers.lib;/usr/local/share/faust/physmodels.lib;/usr/local/share/faust/reducemaps.lib;/usr/local/share/faust/reverbs.lib;/usr/local/share/faust/routes.lib;/usr/local/share/faust/sf.lib;/usr/local/share/faust/signals.lib;/usr/local/share/faust/soundfiles.lib;/usr/local/share/faust/spats.lib;/usr/local/share/faust/stdfaust.lib;/usr/local/share/faust/synths.lib;/usr/local/share/faust/tonestacks.lib;/usr/local/share/faust/tubes.lib;/usr/local/share/faust/vaeffects.lib;/usr/local/share/faust/alchemy-as.cpp;/usr/local/share/faust/alsa-console.cpp;/usr/local/share/faust/alsa-gtk.cpp;/usr/local/share/faust/alsa-qt.cpp;/usr/local/share/faust/au-effect.cpp;/usr/local/share/faust/au-instrument.cpp;/usr/local/share/faust/bela.cpp;/usr/local/share/faust/bench.cpp;/usr/local/share/faust/c-jack-gtk.c;/usr/local/share/faust/ca-qt.cpp;/usr/local/share/faust/csound.cpp;/usr/local/share/faust/csvplot.cpp;/usr/local/share/faust/dssi.cpp;/usr/local/share/faust/dummy-mem.cpp;/usr/local/share/faust/dummy.cpp;/usr/local/share/faust/faust-llvm.cpp;/usr/local/share/faust/faust-netjack-gtk.cpp;/usr/local/share/faust/faustui.js;/usr/local/share/faust/faustvst.cpp;/usr/local/share/faust/faustvstqt.h;/usr/local/share/faust/gen-json.cpp;/usr/local/share/faust/iOSKeyboard.cpp;/usr/local/share/faust/ios-coreaudio-jack.cpp;/usr/local/share/faust/ios-coreaudio.cpp;/usr/local/share/faust/jack-console.cpp;/usr/local/share/faust/jack-gtk-ros.cpp;/usr/local/share/faust/jack-gtk.cpp;/usr/local/share/faust/jack-internal.cpp;/usr/local/share/faust/jack-qt-chain-footer.cpp;/usr/local/share/faust/jack-qt-chain-header.cpp;/usr/local/share/faust/jack-qt.cpp;/usr/local/share/faust/jack-ros.cpp;/usr/local/share/faust/java-minimal.java;/usr/local/share/faust/java-swing.java;/usr/local/share/faust/ladspa.cpp;/usr/local/share/faust/latexheader.tex;/usr/local/share/faust/llvm-jack-gtk.cpp;/usr/local/share/faust/lv2.cpp;/usr/local/share/faust/lv2qtgui.h;/usr/local/share/faust/lv2ui.cpp;/usr/local/share/faust/mathdoctexts-de.txt;/usr/local/share/faust/mathdoctexts-default.txt;/usr/local/share/faust/mathdoctexts-en.txt;/usr/local/share/faust/mathdoctexts-fr.txt;/usr/local/share/faust/mathdoctexts-it.txt;/usr/local/share/faust/matlabplot.cpp;/usr/local/share/faust/minimal-effect.cpp;/usr/local/share/faust/minimal-jack.rs;/usr/local/share/faust/minimal-portaudio.rs;/usr/local/share/faust/minimal.c;/usr/local/share/faust/minimal.cpp;/usr/local/share/faust/minimal.rs;/usr/local/share/faust/module.cpp;/usr/local/share/faust/mr-plot.cpp;/usr/local/share/faust/ms-jack-gtk.cpp;/usr/local/share/faust/netjack-console.cpp;/usr/local/share/faust/netjack-qt.cpp;/usr/local/share/faust/octave.cpp;/usr/local/share/faust/old-scheduler.cpp;/usr/local/share/faust/oscio-gtk.cpp;/usr/local/share/faust/oscio-qt.cpp;/usr/local/share/faust/oss-gtk.cpp;/usr/local/share/faust/owl.cpp;/usr/local/share/faust/pa-gtk.cpp;/usr/local/share/faust/pa-qt.cpp;/usr/local/share/faust/path-printer.cpp;/usr/local/share/faust/plot.cpp;/usr/local/share/faust/pure.c;/usr/local/share/faust/pure.cpp;/usr/local/share/faust/puredata.cpp;/usr/local/share/faust/q.cpp;/usr/local/share/faust/ra-qt.cpp;/usr/local/share/faust/ros-callbacks.cpp;/usr/local/share/faust/scheduler.cpp;/usr/local/share/faust/snd-rt-gtk.cpp;/usr/local/share/faust/sndfile.cpp;/usr/local/share/faust/supercollider.cpp;/usr/local/share/faust/synthfile.cpp;/usr/local/share/faust/thread.h;/usr/local/share/faust/vst.cpp;/usr/local/share/faust/windowsdll.cpp")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/usr/local/share/faust" TYPE FILE PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ FILES
    "/home/dark/proj/faust/libraries/all.lib"
    "/home/dark/proj/faust/libraries/analyzers.lib"
    "/home/dark/proj/faust/libraries/basics.lib"
    "/home/dark/proj/faust/libraries/compressors.lib"
    "/home/dark/proj/faust/libraries/delays.lib"
    "/home/dark/proj/faust/libraries/demos.lib"
    "/home/dark/proj/faust/libraries/dx7.lib"
    "/home/dark/proj/faust/libraries/envelopes.lib"
    "/home/dark/proj/faust/libraries/filters.lib"
    "/home/dark/proj/faust/libraries/hoa.lib"
    "/home/dark/proj/faust/libraries/instruments.lib"
    "/home/dark/proj/faust/libraries/maths.lib"
    "/home/dark/proj/faust/libraries/maxmsp.lib"
    "/home/dark/proj/faust/libraries/mi.lib"
    "/home/dark/proj/faust/libraries/misceffects.lib"
    "/home/dark/proj/faust/libraries/noises.lib"
    "/home/dark/proj/faust/libraries/old/effect.lib"
    "/home/dark/proj/faust/libraries/old/filter.lib"
    "/home/dark/proj/faust/libraries/old/math.lib"
    "/home/dark/proj/faust/libraries/old/music.lib"
    "/home/dark/proj/faust/libraries/old/oscillator.lib"
    "/home/dark/proj/faust/libraries/oscillators.lib"
    "/home/dark/proj/faust/libraries/phaflangers.lib"
    "/home/dark/proj/faust/libraries/physmodels.lib"
    "/home/dark/proj/faust/libraries/reducemaps.lib"
    "/home/dark/proj/faust/libraries/reverbs.lib"
    "/home/dark/proj/faust/libraries/routes.lib"
    "/home/dark/proj/faust/libraries/sf.lib"
    "/home/dark/proj/faust/libraries/signals.lib"
    "/home/dark/proj/faust/libraries/soundfiles.lib"
    "/home/dark/proj/faust/libraries/spats.lib"
    "/home/dark/proj/faust/libraries/stdfaust.lib"
    "/home/dark/proj/faust/libraries/synths.lib"
    "/home/dark/proj/faust/libraries/tonestacks.lib"
    "/home/dark/proj/faust/libraries/tubes.lib"
    "/home/dark/proj/faust/libraries/vaeffects.lib"
    "/home/dark/proj/faust/architecture/alchemy-as.cpp"
    "/home/dark/proj/faust/architecture/alsa-console.cpp"
    "/home/dark/proj/faust/architecture/alsa-gtk.cpp"
    "/home/dark/proj/faust/architecture/alsa-qt.cpp"
    "/home/dark/proj/faust/architecture/au-effect.cpp"
    "/home/dark/proj/faust/architecture/au-instrument.cpp"
    "/home/dark/proj/faust/architecture/bela.cpp"
    "/home/dark/proj/faust/architecture/bench.cpp"
    "/home/dark/proj/faust/architecture/c-jack-gtk.c"
    "/home/dark/proj/faust/architecture/ca-qt.cpp"
    "/home/dark/proj/faust/architecture/csound.cpp"
    "/home/dark/proj/faust/architecture/csvplot.cpp"
    "/home/dark/proj/faust/architecture/dssi.cpp"
    "/home/dark/proj/faust/architecture/dummy-mem.cpp"
    "/home/dark/proj/faust/architecture/dummy.cpp"
    "/home/dark/proj/faust/architecture/faust-llvm.cpp"
    "/home/dark/proj/faust/architecture/faust-netjack-gtk.cpp"
    "/home/dark/proj/faust/architecture/faustui.js"
    "/home/dark/proj/faust/architecture/faustvst.cpp"
    "/home/dark/proj/faust/architecture/faustvstqt.h"
    "/home/dark/proj/faust/architecture/gen-json.cpp"
    "/home/dark/proj/faust/architecture/iOSKeyboard.cpp"
    "/home/dark/proj/faust/architecture/ios-coreaudio-jack.cpp"
    "/home/dark/proj/faust/architecture/ios-coreaudio.cpp"
    "/home/dark/proj/faust/architecture/jack-console.cpp"
    "/home/dark/proj/faust/architecture/jack-gtk-ros.cpp"
    "/home/dark/proj/faust/architecture/jack-gtk.cpp"
    "/home/dark/proj/faust/architecture/jack-internal.cpp"
    "/home/dark/proj/faust/architecture/jack-qt-chain-footer.cpp"
    "/home/dark/proj/faust/architecture/jack-qt-chain-header.cpp"
    "/home/dark/proj/faust/architecture/jack-qt.cpp"
    "/home/dark/proj/faust/architecture/jack-ros.cpp"
    "/home/dark/proj/faust/architecture/java-minimal.java"
    "/home/dark/proj/faust/architecture/java-swing.java"
    "/home/dark/proj/faust/architecture/ladspa.cpp"
    "/home/dark/proj/faust/architecture/latexheader.tex"
    "/home/dark/proj/faust/architecture/llvm-jack-gtk.cpp"
    "/home/dark/proj/faust/architecture/lv2.cpp"
    "/home/dark/proj/faust/architecture/lv2qtgui.h"
    "/home/dark/proj/faust/architecture/lv2ui.cpp"
    "/home/dark/proj/faust/architecture/mathdoctexts-de.txt"
    "/home/dark/proj/faust/architecture/mathdoctexts-default.txt"
    "/home/dark/proj/faust/architecture/mathdoctexts-en.txt"
    "/home/dark/proj/faust/architecture/mathdoctexts-fr.txt"
    "/home/dark/proj/faust/architecture/mathdoctexts-it.txt"
    "/home/dark/proj/faust/architecture/matlabplot.cpp"
    "/home/dark/proj/faust/architecture/minimal-effect.cpp"
    "/home/dark/proj/faust/architecture/minimal-jack.rs"
    "/home/dark/proj/faust/architecture/minimal-portaudio.rs"
    "/home/dark/proj/faust/architecture/minimal.c"
    "/home/dark/proj/faust/architecture/minimal.cpp"
    "/home/dark/proj/faust/architecture/minimal.rs"
    "/home/dark/proj/faust/architecture/module.cpp"
    "/home/dark/proj/faust/architecture/mr-plot.cpp"
    "/home/dark/proj/faust/architecture/ms-jack-gtk.cpp"
    "/home/dark/proj/faust/architecture/netjack-console.cpp"
    "/home/dark/proj/faust/architecture/netjack-qt.cpp"
    "/home/dark/proj/faust/architecture/octave.cpp"
    "/home/dark/proj/faust/architecture/old-scheduler.cpp"
    "/home/dark/proj/faust/architecture/oscio-gtk.cpp"
    "/home/dark/proj/faust/architecture/oscio-qt.cpp"
    "/home/dark/proj/faust/architecture/oss-gtk.cpp"
    "/home/dark/proj/faust/architecture/owl.cpp"
    "/home/dark/proj/faust/architecture/pa-gtk.cpp"
    "/home/dark/proj/faust/architecture/pa-qt.cpp"
    "/home/dark/proj/faust/architecture/path-printer.cpp"
    "/home/dark/proj/faust/architecture/plot.cpp"
    "/home/dark/proj/faust/architecture/pure.c"
    "/home/dark/proj/faust/architecture/pure.cpp"
    "/home/dark/proj/faust/architecture/puredata.cpp"
    "/home/dark/proj/faust/architecture/q.cpp"
    "/home/dark/proj/faust/architecture/ra-qt.cpp"
    "/home/dark/proj/faust/architecture/ros-callbacks.cpp"
    "/home/dark/proj/faust/architecture/scheduler.cpp"
    "/home/dark/proj/faust/architecture/snd-rt-gtk.cpp"
    "/home/dark/proj/faust/architecture/sndfile.cpp"
    "/home/dark/proj/faust/architecture/supercollider.cpp"
    "/home/dark/proj/faust/architecture/synthfile.cpp"
    "/home/dark/proj/faust/architecture/thread.h"
    "/home/dark/proj/faust/architecture/vst.cpp"
    "/home/dark/proj/faust/architecture/windowsdll.cpp"
    )
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/usr/local/share/faust/android;/usr/local/share/faust/api;/usr/local/share/faust/AU;/usr/local/share/faust/iOS;/usr/local/share/faust/juce;/usr/local/share/faust/max-msp;/usr/local/share/faust/nodejs;/usr/local/share/faust/osclib;/usr/local/share/faust/sam;/usr/local/share/faust/smartKeyboard;/usr/local/share/faust/unity;/usr/local/share/faust/webaudio;/usr/local/share/faust/js")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/usr/local/share/faust" TYPE DIRECTORY PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ DIR_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE FILES
    "/home/dark/proj/faust/architecture/android"
    "/home/dark/proj/faust/architecture/api"
    "/home/dark/proj/faust/architecture/AU"
    "/home/dark/proj/faust/architecture/iOS"
    "/home/dark/proj/faust/architecture/juce"
    "/home/dark/proj/faust/architecture/max-msp"
    "/home/dark/proj/faust/architecture/nodejs"
    "/home/dark/proj/faust/architecture/osclib"
    "/home/dark/proj/faust/architecture/sam"
    "/home/dark/proj/faust/architecture/smartKeyboard"
    "/home/dark/proj/faust/architecture/unity"
    "/home/dark/proj/faust/architecture/webaudio"
    "/home/dark/proj/faust/architecture/httpdlib/html/js"
    REGEX "/\\.DS\\_Store$" EXCLUDE REGEX "/[^/]*\\.o$" EXCLUDE)
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/home/dark/proj/faust/build/faustdir/emcc/cmake_install.cmake")
  include("/home/dark/proj/faust/build/faustdir/osc/cmake_install.cmake")
  include("/home/dark/proj/faust/build/faustdir/http/cmake_install.cmake")
  include("/home/dark/proj/faust/build/faustdir/interp/cmake_install.cmake")

endif()

if(CMAKE_INSTALL_COMPONENT)
  set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
file(WRITE "/home/dark/proj/faust/build/faustdir/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
