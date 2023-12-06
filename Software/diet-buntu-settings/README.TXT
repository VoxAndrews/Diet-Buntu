//////////////////////////////////////////////////////////////////////////////////
    BUILDING ON UBUNTU 22.04

    NOTE: If possible, try to build the program using Diet-Buntu as it will be
        the closest representation of the end result.
//////////////////////////////////////////////////////////////////////////////////

1. Install the necessary packages:
    - sudo apt update && apt install build-essential cmake pkg-config libgtk-3-dev
2. Navigate to the project build directory
3. Run Cmake to configure the project
    - cmake ..
4. If all is good, build the project
    - cmake --build .

ADDITIONAL NOTES:
    - For styling adjustments in GTK3, you might find the GTK Inspector tool 
        useful. It can be enabled by setting an environment variable: 
        'export GTK_DEBUG=interactive' before running your application.

//////////////////////////////////////////////////////////////////////////////////
    BUILDING ON WINDOWS

    NOTE: Windows is NOT the intended target OS for this program. Only use it to
        make fine adjustments to the styling of the program through GTK3 if 
        needed. Please use Ubuntu 22.04, or better yet, Diet-Buntu, to develop
        core functionality and implement final stylings. All building and running
        of the program must be done from MSYS2 MINGW64, it will crash if you try
        to run it from the file explorer.
//////////////////////////////////////////////////////////////////////////////////

1. Install MSYS2 and install the necessary packages:
    - pacman -Syu mingw-w64-x86_64-gtk3 mingw-w64-x86_64-cmake mingw-w64-x86_64-toolchain make
2. Install 'GCC 11.2.0 + MinGW-w64 10.0.0 (UCRT) - release 1' binaries from WinLibs and install it to a directory you will remember
    - https://github.com/brechtsanders/winlibs_mingw/releases/download/11.2.0-10.0.0-ucrt-r1/winlibs-x86_64-posix-seh-gcc-11.2.0-mingw-w64ucrt-10.0.0-r1.zip
3. Add GCC 11.2.0 to your System Path
4. Open MSYS2 MINGW64 and move into the build directory of the project
5. Run the following cmake command, with the path to your GCC 11.2.0 install set:
    - cmake -G "MinGW Makefiles" -DCMAKE_C_COMPILER="C:/path/to/gcc.exe" -DCMAKE_CXX_COMPILER="C:/path/to/g++.exe" ..
6. If there are no errors, build the program with the following cmake command:
    - cmake --build .