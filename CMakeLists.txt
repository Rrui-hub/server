cmake_minimum_required(VERSION 3.25)

# Force a specific compiler toolchain for reproducible builds across environments.
set(CMAKE_C_COMPILER "/usr/bin/gcc" CACHE FILEPATH "C compiler" FORCE)
set(CMAKE_CXX_COMPILER "/usr/bin/g++" CACHE FILEPATH "C++ compiler" FORCE)

# Require a modern C++ standard for the project sources.
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS ON)

# Define the project metadata and enable common package helpers.
project(pans VERSION 0.1.0 LANGUAGES CXX C)
include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

# Build-time toggles for optional components.
option(PANS_BUILD_EXAMPLES "build examples" ON)
option(PANS_BUILD_TOOLS "build tools" ON)
option(PANS_BUILD_TESTS "build tests" ON)

# Default to a Debug build when no configuration is explicitly selected.
if(NOT CMAKE_CONFIGURATION_TYPES AND NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug CACHE STRING "Choose the type of build." FORCE)
endif()

# Expose the supported build types to CMake's cache UI.
set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "RelWithDebInfo" "MinSizeRel")
message(STATUS "Build Type: ${CMAKE_BUILD_TYPE}")

# Tune the default parallel build level to the machine's CPU resources.
cmake_host_system_information(RESULT CPU_NUMS QUERY NUMBER_OF_LOGICAL_CORES)
message(STATUS "CPU NUMS on current server is: ${CPU_NUMS}")
math(EXPR JOBS "${CPU_NUMS} + ${CPU_NUMS} / 2")
set(CMAKE_BUILD_PARALLEL_LEVEL ${JOBS} CACHE STRING "并行编译的线程数")
message(STATUS "Compiler default work jobs: ${CMAKE_BUILD_PARALLEL_LEVEL}")

include(./cmake/pansOptions.cmake)
add_subdirectory(pans)
if(PANS_BUILD_TESTS)
    enable_testing()
    add_subdirectory(tests)
endif()
if(PANS_BUILD_TOOLS)
    add_subdirectory(tools)
endif()