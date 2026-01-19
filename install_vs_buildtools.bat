@echo off
REM Visual Studio Build Tools Silent Installer
REM This installs only the command-line build tools (no full IDE)

echo Installing Visual Studio Build Tools...
echo This will download ~2-3 GB and take 5-10 minutes.

REM Download VS Build Tools installer
curl -L -o vs_buildtools.exe "https://aka.ms/vs/17/release/vs_buildtools.exe"

REM Install with minimal components
vs_buildtools.exe ^
    --quiet ^
    --wait ^
    --norestart ^
    --add ^
        Microsoft.VisualStudio.Component.VC.Tools.x86.x64 ^
    --add ^
        Microsoft.VisualStudio.Component.Windows11SDK.22621 ^
    --add ^
        Microsoft.Component.MSBuild ^
    --add ^
        Microsoft.VisualStudio.Component.CMake

REM Cleanup
del vs_buildtools.exe

echo.
echo ========================================
echo Installation complete!
echo.
echo Restart your terminal or run:
echo   call "C:\Program Files\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
echo.
echo Then you can build JUCE 8 VST3 plugins.
echo ========================================

pause
