# PowerShell script to build JUCE 8 VST3 plugin
# Run this in PowerShell (Windows) after installing VS Build Tools

param(
    [string]$JUCE_PATH = "C:/Users/indraqubit/Downloads/JUCE",
    [string]$PROJECT_PATH = "C:/Users/indraqubit/Downloads/MyPlugin",
    [string]$OUTPUT_PATH = "C:/Users/indraqubit/Downloads/Build",
    [string]$PLUGIN_NAME = "MyPlugin"
)

Write-Host "=======================================" -ForegroundColor Cyan
Write-Host "JUCE 8 VST3 Build Script" -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan
Write-Host ""

# 1. Initialize Visual Studio Build Tools
Write-Host "[1/4] Initializing Visual Studio Build Tools..." -ForegroundColor Yellow
$vcvars = "C:\Program Files\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
if (-not (Test-Path $vcvars)) {
    Write-Error "VS Build Tools not found! Run install_vs_buildtools.bat first."
    exit 1
}

# Import environment variables from vcvars64.bat into the current PowerShell session
$envOutput = cmd /c "\"$vcvars\" >nul && set"
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to initialize MSVC environment."
    exit 1
}
foreach ($line in $envOutput) {
    if ($line -match '^(.*?)=(.*)$') {
        $name = $matches[1]
        $value = $matches[2]
        Set-Item -Path "env:$name" -Value $value
    }
}

# 2. Create build directory
Write-Host "[2/4] Preparing build directory..." -ForegroundColor Yellow
if (Test-Path $OUTPUT_PATH) {
    Remove-Item -Recurse -Force $OUTPUT_PATH
}
New-Item -ItemType Directory -Force -Path $OUTPUT_PATH | Out-Null
Set-Location $OUTPUT_PATH

# 3. Configure with CMake
Write-Host "[3/4] Configuring with CMake..." -ForegroundColor Yellow
cmake $PROJECT_PATH `
    -G "Visual Studio 17 2022" `
    -A x64 `
    -DCMAKE_BUILD_TYPE=Release `
    -DJUCE_GENERATE_JUCE_CMAKE=ON `
    -DJUCE_BUILD_EXAMPLES=OFF

if ($LASTEXITCODE -ne 0) {
    Write-Error "CMake configuration failed!"
    exit 1
}

# 4. Build
Write-Host "[4/4] Building $PLUGIN_NAME..." -ForegroundColor Yellow
cmake --build . --config Release --parallel

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "=======================================" -ForegroundColor Green
    Write-Host "Build SUCCESS!" -ForegroundColor Green
    Write-Host "Output: $OUTPUT_PATH" -ForegroundColor Green
    Write-Host "=======================================" -ForegroundColor Green
} else {
    Write-Error "Build failed!"
    exit 1
}
