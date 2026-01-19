# JUCE 8 Windows Build Toolchain for WSL
# Usage: cmake -DCMAKE_TOOLCHAIN_FILE=juce8-windows-toolchain.cmake ..

# Target Windows
set(CMAKE_SYSTEM_NAME Windows)
set(CMAKE_SYSTEM_PROCESSOR x86_64)

# Windows SDK and MSVC paths (adjust version as needed)
set(WindowsSDK_VERSION "10.0.22621.0")
set(VS_BUILDTOOLS_PATH "C:/Program Files/Microsoft Visual Studio/2022/BuildTools")
set(WindowsSDK_PATH "C:/Program Files (x86)/Windows Kits/10")

# Cross-compiler settings
set(CMAKE_C_COMPILER "${VS_BUILDTOOLS_PATH}/VC/Tools/MSVC/14.36.32532/cl.exe")
set(CMAKE_CXX_COMPILER "${VS_BUILDTOOLS_PATH}/VC/Tools/MSVC/14.36.32532/cl.exe")
set(CMAKE_RC_COMPILER "${WindowsSDK_PATH}/bin/${WindowsSDK_VERSION}/x64/rc.exe")

# Linker
set(CMAKE_LINKER "${VS_BUILDTOOLS_PATH}/VC/Tools/MSVC/14.36.32532/link.exe")

# Find programs for platform tools
set(CMAKE_FIND_ROOT_PATH "${VS_BUILDTOOLS_PATH}/VC/Tools/MSVC/14.36.32532")

# Search programs in the target environment, not host
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

# Windows-specific
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
