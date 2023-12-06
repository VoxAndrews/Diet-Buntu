cmake_minimum_required(VERSION 3.10)
project(DietBuntuSettings)

# Find the package for GTK3
find_package(PkgConfig REQUIRED)
pkg_check_modules(GTK3 REQUIRED gtk+-3.0)

# Include GTK3 directories
include_directories(${GTK3_INCLUDE_DIRS})
link_directories(${GTK3_LIBRARY_DIRS})

# Add other definitions
add_definitions(${GTK3_CFLAGS_OTHER})

# Specify the C++ Standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Source files
set(SOURCES src/main.cpp) # Add other source files here

# Include directory for header files
include_directories(include)

# Define the executable
add_executable(DietBuntuSettings ${SOURCES})

# Link with GTK3
target_link_libraries(DietBuntuSettings ${GTK3_LIBRARIES})