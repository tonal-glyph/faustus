# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.14

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/dark/proj/faust/build

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/dark/proj/faust/build/faustdir

# Include any dependencies generated for this target.
include interp/CMakeFiles/faustmachinedynamic.dir/depend.make

# Include the progress variables for this target.
include interp/CMakeFiles/faustmachinedynamic.dir/progress.make

# Include the compile flags for this target's objects.
include interp/CMakeFiles/faustmachinedynamic.dir/flags.make

interp/CMakeFiles/faustmachinedynamic.dir/home/dark/proj/faust/compiler/generator/export.cpp.o: interp/CMakeFiles/faustmachinedynamic.dir/flags.make
interp/CMakeFiles/faustmachinedynamic.dir/home/dark/proj/faust/compiler/generator/export.cpp.o: /home/dark/proj/faust/compiler/generator/export.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/dark/proj/faust/build/faustdir/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object interp/CMakeFiles/faustmachinedynamic.dir/home/dark/proj/faust/compiler/generator/export.cpp.o"
	cd /home/dark/proj/faust/build/faustdir/interp && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/faustmachinedynamic.dir/home/dark/proj/faust/compiler/generator/export.cpp.o -c /home/dark/proj/faust/compiler/generator/export.cpp

interp/CMakeFiles/faustmachinedynamic.dir/home/dark/proj/faust/compiler/generator/export.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/faustmachinedynamic.dir/home/dark/proj/faust/compiler/generator/export.cpp.i"
	cd /home/dark/proj/faust/build/faustdir/interp && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/dark/proj/faust/compiler/generator/export.cpp > CMakeFiles/faustmachinedynamic.dir/home/dark/proj/faust/compiler/generator/export.cpp.i

interp/CMakeFiles/faustmachinedynamic.dir/home/dark/proj/faust/compiler/generator/export.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/faustmachinedynamic.dir/home/dark/proj/faust/compiler/generator/export.cpp.s"
	cd /home/dark/proj/faust/build/faustdir/interp && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/dark/proj/faust/compiler/generator/export.cpp -o CMakeFiles/faustmachinedynamic.dir/home/dark/proj/faust/compiler/generator/export.cpp.s

interp/CMakeFiles/faustmachinedynamic.dir/home/dark/proj/faust/compiler/generator/interpreter/interpreter_dsp_aux.cpp.o: interp/CMakeFiles/faustmachinedynamic.dir/flags.make
interp/CMakeFiles/faustmachinedynamic.dir/home/dark/proj/faust/compiler/generator/interpreter/interpreter_dsp_aux.cpp.o: /home/dark/proj/faust/compiler/generator/interpreter/interpreter_dsp_aux.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/dark/proj/faust/build/faustdir/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object interp/CMakeFiles/faustmachinedynamic.dir/home/dark/proj/faust/compiler/generator/interpreter/interpreter_dsp_aux.cpp.o"
	cd /home/dark/proj/faust/build/faustdir/interp && /usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/faustmachinedynamic.dir/home/dark/proj/faust/compiler/generator/interpreter/interpreter_dsp_aux.cpp.o -c /home/dark/proj/faust/compiler/generator/interpreter/interpreter_dsp_aux.cpp

interp/CMakeFiles/faustmachinedynamic.dir/home/dark/proj/faust/compiler/generator/interpreter/interpreter_dsp_aux.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/faustmachinedynamic.dir/home/dark/proj/faust/compiler/generator/interpreter/interpreter_dsp_aux.cpp.i"
	cd /home/dark/proj/faust/build/faustdir/interp && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/dark/proj/faust/compiler/generator/interpreter/interpreter_dsp_aux.cpp > CMakeFiles/faustmachinedynamic.dir/home/dark/proj/faust/compiler/generator/interpreter/interpreter_dsp_aux.cpp.i

interp/CMakeFiles/faustmachinedynamic.dir/home/dark/proj/faust/compiler/generator/interpreter/interpreter_dsp_aux.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/faustmachinedynamic.dir/home/dark/proj/faust/compiler/generator/interpreter/interpreter_dsp_aux.cpp.s"
	cd /home/dark/proj/faust/build/faustdir/interp && /usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/dark/proj/faust/compiler/generator/interpreter/interpreter_dsp_aux.cpp -o CMakeFiles/faustmachinedynamic.dir/home/dark/proj/faust/compiler/generator/interpreter/interpreter_dsp_aux.cpp.s

# Object files for target faustmachinedynamic
faustmachinedynamic_OBJECTS = \
"CMakeFiles/faustmachinedynamic.dir/home/dark/proj/faust/compiler/generator/export.cpp.o" \
"CMakeFiles/faustmachinedynamic.dir/home/dark/proj/faust/compiler/generator/interpreter/interpreter_dsp_aux.cpp.o"

# External object files for target faustmachinedynamic
faustmachinedynamic_EXTERNAL_OBJECTS =

../lib/libfaustmachine.so.1.0.0: interp/CMakeFiles/faustmachinedynamic.dir/home/dark/proj/faust/compiler/generator/export.cpp.o
../lib/libfaustmachine.so.1.0.0: interp/CMakeFiles/faustmachinedynamic.dir/home/dark/proj/faust/compiler/generator/interpreter/interpreter_dsp_aux.cpp.o
../lib/libfaustmachine.so.1.0.0: interp/CMakeFiles/faustmachinedynamic.dir/build.make
../lib/libfaustmachine.so.1.0.0: interp/CMakeFiles/faustmachinedynamic.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/dark/proj/faust/build/faustdir/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Linking CXX shared library ../../lib/libfaustmachine.so"
	cd /home/dark/proj/faust/build/faustdir/interp && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/faustmachinedynamic.dir/link.txt --verbose=$(VERBOSE)
	cd /home/dark/proj/faust/build/faustdir/interp && $(CMAKE_COMMAND) -E cmake_symlink_library ../../lib/libfaustmachine.so.1.0.0 ../../lib/libfaustmachine.so.0 ../../lib/libfaustmachine.so

../lib/libfaustmachine.so.0: ../lib/libfaustmachine.so.1.0.0
	@$(CMAKE_COMMAND) -E touch_nocreate ../lib/libfaustmachine.so.0

../lib/libfaustmachine.so: ../lib/libfaustmachine.so.1.0.0
	@$(CMAKE_COMMAND) -E touch_nocreate ../lib/libfaustmachine.so

# Rule to build all files generated by this target.
interp/CMakeFiles/faustmachinedynamic.dir/build: ../lib/libfaustmachine.so

.PHONY : interp/CMakeFiles/faustmachinedynamic.dir/build

interp/CMakeFiles/faustmachinedynamic.dir/clean:
	cd /home/dark/proj/faust/build/faustdir/interp && $(CMAKE_COMMAND) -P CMakeFiles/faustmachinedynamic.dir/cmake_clean.cmake
.PHONY : interp/CMakeFiles/faustmachinedynamic.dir/clean

interp/CMakeFiles/faustmachinedynamic.dir/depend:
	cd /home/dark/proj/faust/build/faustdir && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/dark/proj/faust/build /home/dark/proj/faust/build/interp /home/dark/proj/faust/build/faustdir /home/dark/proj/faust/build/faustdir/interp /home/dark/proj/faust/build/faustdir/interp/CMakeFiles/faustmachinedynamic.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : interp/CMakeFiles/faustmachinedynamic.dir/depend

