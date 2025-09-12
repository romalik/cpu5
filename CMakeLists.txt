cmake_minimum_required(VERSION 3.20)
project(cpu5 C CXX)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(FIRMWARE_DIR "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/fw")
# Options / knobs (override with -D...)
option(CPU5_ENABLE_VERILATOR "Build Verilator-based simulator" ON)
set(CPU5_BUILD_TYPE "Debug" CACHE STRING "Build type (Debug/Release/RelWithDebInfo/MinSizeRel)")

# Default C++ flags (aggressive but sane); refine per-target below
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
add_compile_options(-Wall -Wextra -Wpedantic)

# Common include for shared headers later (if/when you split headers out)
# include_directories(${CMAKE_SOURCE_DIR}/include)

# Build the shared common library
add_subdirectory(simulation/common)

find_package(Verilator QUIET)

if(NOT Verilator_FOUND)
  # Fallback to custom finder (optional). Otherwise, rely on $PATH.
  list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")
  find_package(Verilator REQUIRED)
endif()

add_subdirectory(simulation/verilator)
add_subdirectory(simulation/logic)
add_subdirectory(binutils)
add_subdirectory(alu)
add_subdirectory(microcode)
add_subdirectory(tools)
add_subdirectory(compiler/ucpp)
add_subdirectory(compiler/smlrc)
