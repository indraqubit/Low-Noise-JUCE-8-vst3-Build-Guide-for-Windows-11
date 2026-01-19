# Panduan Build JUCE 8 VST3 dari WSL/Windows

## Daftar Isi

1. [Pendahuluan](#pendahuluan)
2. [Mengapa Setup Ini?](#mengapa-setup-ini)
3. [Arsitektur Sistem](#arsitektur-sistem)
4. [Prasyarat](#prasyarat)
5. [Instalasi](#instalasi)
6. [Konfigurasi Project](#konfigurasi-project)
7. [Proses Build](#proses-build)
8. [Tips Environment Windows yang Lebih Tenang](#tips-environment-windows-yang-lebih-tenang)
9. [Troubleshooting](#troubleshooting)
10. [FAQ](#faq)

---

## Pendahuluan

Dokumen ini menjelaskan cara membangun plugin VST3 menggunakan JUCE 8 dari environment WSL (Windows Subsystem for Linux) dengan build environment di Windows.

Plugin yang dihasilkan dapat digunakan di DAW seperti Cubase, REAPER, FL Studio, dan lainnya.

**Target Platform:** Windows 10/11 (64-bit)  
**Format Plugin:** VST3  
**Compiler:** MSVC (Visual Studio Build Tools)

---

## Mengapa Setup Ini?

### Permasalahan Umum

#### 1. Cross-Compile MinGW Tidak Didukung di JUCE 8

JUCE 8 memiliki perubahan signifikan dibanding JUCE 7:

| Fitur | JUCE 7 | JUCE 8 |
|-------|--------|--------|
| Direct2D Renderer | Tidak | Ya (default) |
| MinGW Cross-compile | Didukung | Tidak didukung |
| MSVC | Didukung | Wajib untuk Windows |
| Windows SDK | Opsional | Diperlukan |

**Alasan utama MinGW tidak didukung:**
- Direct2D adalah native Windows API yang sangat terintegrasi dengan Windows SDK
- JUCE 8 menggunakan fitur C++ modern yang memerlukan MSVC runtime
- Windows 10+ only requirement meningkatkan kompleksitas cross-compile

#### 2. Visual Studio Full Terlalu Berat

Visual Studio Community dengan Desktop Development workload membutuhkan **~20 GB** disk space dan memiliki banyak komponen yang tidak diperlukan untuk build command-line.

### Solusi: Visual Studio Build Tools

VS Build Tools menyediakan:
- **Compiler:** MSVC (C++)
- **Linker:** LINK.EXE
- **SDK:** Windows 11 SDK
- **Build Tools:** CMake, MSBuild

**Ukuran: ~2-3 GB** saja.

### Keuntungan Setup Ini

1. **Ringan** - Tidak ada GUI yang "berisik"
2. **Cepat** - Command-line build lebih efisien
3. **Fleksibel** - Bisa diintegrasikan dengan CI/CD
4. **Native** - Build environment persis seperti production
5. **WSL Ready** - Coding di Linux, build di Windows

---

## Arsitektur Sistem

```
┌─────────────────────────────────────────────────────────────────┐
│                        WSL (Linux)                              │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  Coding/Development                                        │  │
│  │  - Source code editing                                     │  │
│  │  - Git version control                                     │  │
│  │  - Testing di Linux (jika applicable)                      │  │
│  │  - File sync via /mnt/c/                                   │  │
│  └───────────────────────────────────────────────────────────┘  │
│                              │                                   │
│                              ▼                                   │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  File Access via /mnt/c/                                   │  │
│  │  - Source files                                            │  │
│  │  - Build scripts                                           │  │
│  │  - Output (.vst3)                                          │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              │ Network/Shared Mount
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Windows 11 (Native)                        │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  Visual Studio Build Tools                                 │  │
│  │  - MSVC Compiler (cl.exe)                                  │  │
│  │  - Windows SDK                                             │  │
│  │  - CMake                                                   │  │
│  │  - Linker (link.exe)                                       │  │
│  └───────────────────────────────────────────────────────────┘  │
│                              │                                   │
│                              ▼                                   │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  Output                                                    │  │
│  │  - MyPlugin.vst3                                           │  │
│  │  - Ready untuk DAW installation                            │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Prasyarat

### Hardware

| Komponen | Minimum | Rekomendasi |
|----------|---------|-------------|
| RAM | 8 GB | 16 GB+ |
| Disk | 10 GB free | 20 GB+ SSD |
| CPU | Dual-core | Quad-core+ |

### Software

#### WSL (Linux)

```
# Cek versi WSL
wsl --version

# Distro yang didukung
- Ubuntu 20.04+
- Debian 11+
- Arch WSL
```

#### Windows 11

```
# Pastikan terinstall
- Windows 11 (atau Windows 10 1903+)
- PowerShell 5.1+
- ~3 GB free disk space
```

#### JUCE 8

Download dari: https://github.com/juce-framework/JUCE

```
Folder structure:
C:\Users\<USER>\Downloads\JUCE\
├── JUCE/
│   ├── cmake/
│   ├── modules/
│   └── ...
```

---

## Instalasi

### Langkah 1: Install Visual Studio Build Tools

#### Metode 1: Script Otomatis (Direkomendasikan)

Jalankan sebagai **Administrator**:

```batch
cd C:\Users\indraqubit\Downloads
install_vs_buildtools.bat
```

Script ini akan:
1. Download VS Build Tools installer (~1 MB)
2. Install komponen berikut:
   - MSVC v143 - VS 2022 C++ x64/x86 build tools
   - Windows 11 SDK (10.0.22621.0)
   - CMake Tools
3. Total ukuran: ~2-3 GB
4. Waktu install: 5-15 menit

#### Metode 2: Manual Install

1. Download dari: https://visualstudio.microsoft.com/visual-cpp-build-tools/
2. Run installer
3. Pilih "Desktop development with C++"
4. Di tab "Individual components", pastikan:
   - MSVC v143 - VS 2022 C++ x64/x86 build tools
   - Windows 11 SDK (10.0.22621.0)
   - C++ ATL for latest build tools
5. Install

#### Metode 3: Via Command Line

```powershell
# Download installer
curl -L -o vs_buildtools.exe "https://aka.ms/vs/17/release/vs_buildtools.exe"

# Install dengan komponen spesifik
vs_buildtools.exe `
    --quiet `
    --wait `
    --norestart `
    --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 `
    --add Microsoft.VisualStudio.Component.Windows11SDK.22621 `
    --add Microsoft.Component.MSBuild `
    --add Microsoft.VisualStudio.Component.CMAKE
```

### Langkah 2: Verifikasi Instalasi

Buka **Developer Command Prompt** atau **PowerShell**:

```powershell
# Cek MSVC
cl.exe

# Hasil seharusnya:
# Microsoft (R) C/C++ Optimizing Compiler Version 19.36.32532 for x64
# Copyright (C) Microsoft Corporation. All rights reserved.

# Cek Windows SDK
rc.exe

# Hasil:
# Microsoft (R) Windows (R) Resource Compiler Version 10.0.22621.755

# Cek CMake
cmake --version

# Hasil:
# cmake version 3.26.0
```

### Langkah 3: Initialize Environment

Setiap session PowerShell/CMD baru, jalankan:

```batch
call "C:\Program Files\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
```

Atau bisa dipermanent-in di PowerShell Profile (import env dari `vcvars64.bat`):

```powershell
# Edit profile
notepad $PROFILE

# Tambah baris ini:
$vcvars = "C:\Program Files\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
& cmd /c "\"$vcvars\" >nul && set" | ForEach-Object {
    if ($_ -match '^(.*?)=(.*)$') { Set-Item -Path "env:$($matches[1])" -Value $matches[2] }
}
```

---

## Konfigurasi Project

### Struktur Folder Plugin

```
MyPlugin/
├── CMakeLists.txt              # Konfigurasi CMake
├── Source/
│   ├── PluginProcessor.cpp     # DSP logic
│   ├── PluginProcessor.h
│   ├── PluginEditor.cpp        # GUI
│   └── PluginEditor.h
└── Resources/
    └── icon.png               # Plugin icon
```

### CMakeLists.txt Lengkap

```cmake
cmake_minimum_required(VERSION 3.20)
project(MyPlugin VERSION 1.0.0 LANGUAGES CXX)

# =============================================================================
# JUCE Configuration
# =============================================================================
set(JUCE_PATH "C:/Users/indraqubit/Downloads/JUCE")
list(APPEND CMAKE_MODULE_PATH "${JUCE_PATH}/cmake")

juce_set_version(1.0.0)
message(STATUS "JUCE Version: ${JUCE_VERSION}")

# =============================================================================
# Plugin Metadata
# =============================================================================
juce_add_plugin(MyPlugin
    VERSION_STRING "1.0.0"
    COMPANY_NAME "NamaPerusahaan"
    COMPANY_COPYRIGHT "Copyright © 2025 NamaPerusahaan"
    PLUGIN_MANUFACTURER_CODE "MfgC"     # 4 karakter unik (registrasi di Steinberg)
    PLUGIN_CODE "Plg1"                  # 4 karakter unik per plugin
    FORMATS VST3
    NEEDS_MIDI_INPUT FALSE
    NEEDS_MIDI_OUTPUT FALSE
    IS_SYNTH FALSE
    EDITOR_WANTS_KEYBOARD_FOCUS TRUE
    VST3_CATEGORIES "Fx"
)

# =============================================================================
# Source Files
# =============================================================================
set(SOURCES
    Source/PluginProcessor.cpp
    Source/PluginProcessor.h
    Source/PluginEditor.cpp
    Source/PluginEditor.h
)

set(HEADERS
    Source/PluginProcessor.h
    Source/PluginEditor.h
)

# =============================================================================
# Compiler Options
# =============================================================================
if(MSVC)
    # Disable warnings yang tidak perlu
    target_compile_options(MyPlugin PRIVATE
        /W4                  # Warning level 4
        /WX-                 # Warnings not as errors (ubah ke /WX jika mau strict)
        /utf-8              # UTF-8 source and execution charset
        /permissive-        # Strict conformance mode
        /Zc:__cplusplus      # Correct __cplusplus macro
    )
    
    # Optimizations
    target_compile_options(MyPlugin PRIVATE
        /O2                  # Maximum optimization
        /Oi                  # Intrinsic functions
        /GL                  # Whole program optimization
        /Gy                  # Function-level linking
    )
    
    # Linker optimizations
    target_link_options(MyPlugin PRIVATE
        /LTCG                # Link-time code generation
        /OPT:REF             # Remove unreferenced functions
        /OPT:ICF             # Identical COMDAT folding
    )
endif()

# =============================================================================
# JUCE Modules
# =============================================================================
target_link_libraries(MyPlugin PRIVATE
    # Core modules
    juce::juce_core
    juce::juce_events
    juce::juce_graphics
    juce::juce_gui_basics
    juce::juce_audio_processors
    juce::juce_dsp
    
    # Optional: tambah module sesuai kebutuhan
    # juce::juce_audio_devices
    # juce::juce_audio_utils
)

# =============================================================================
# Post-Build: Copy VST3 ke folder tertentu
# =============================================================================
if(WIN32 AND VST3_FOUND)
    add_custom_command(TARGET MyPlugin POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy
            "$<TARGET_FILE:MyPlugin>"
            "${CMAKE_SOURCE_DIR}/build/$<CONFIG>/MyPlugin.vst3"
        COMMENT "Copying VST3 to build folder"
    )
endif()

# =============================================================================
# Install Rules (optional)
# =============================================================================
if(WIN32)
    install(TARGETS MyPlugin
        RUNTIME DESTINATION "VST3"
        COMPONENT Runtime
    )
endif()
```

### Penjelasan Konfigurasi Penting

#### Plugin Codes

```
PLUGIN_MANUFACTURER_CODE: 4 karakter unik yang merepresentasikan company
                          Registrasi di: https://www.steinberg.net/developers/
                          
PLUGIN_CODE: 4 karakter unik per plugin
             Contoh: Jika MfgC = "MfgC", plugin pertama bisa "Pf01"
```

#### Format Plugin

```cmake
FORMATS VST3     # Steinberg VST3 (standar saat ini)
FORMATS AU       # Apple AudioUnit (hanya macOS)
FORMATS AAX      # Avid Pro Tools (memerlukan license)
```

#### MSVC Compiler Options

| Option | Fungsi |
|--------|--------|
| `/O2` | Maximum optimization (speed) |
| `/Oi` | Intrinsic functions (faster math) |
| `/GL` | Whole program optimization |
| `/LTCG` | Link-time code generation |
| `/OPT:REF` | Remove unreferenced code |
| `/OPT:ICF` | Fold identical functions |

---

## Proses Build

### Metode 1: PowerShell Script (Direkomendasikan)

```powershell
# Buka PowerShell sebagai Administrator
cd C:\Users\indraqubit\Downloads

# Jalankan build
.\build_juce8_vst3.ps1 `
    -JUCE_PATH "C:\Users\indraqubit\Downloads\JUCE" `
    -PROJECT_PATH "C:\Users\indraqubit\Downloads\MyPlugin" `
    -OUTPUT_PATH "C:\Users\indraqubit\Downloads\Build" `
    -PLUGIN_NAME "MyPlugin"
```

### Metode 2: Manual via Command Line

```batch
REM 1. Initialize environment
call "C:\Program Files\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"

REM 2. Create build directory
mkdir C:\Users\indraqubit\Downloads\Build
cd C:\Users\indraqubit\Downloads\Build

REM 3. Configure
cmake ..\MyPlugin `
    -G "Visual Studio 17 2022" `
    -A x64 `
    -DCMAKE_BUILD_TYPE=Release `
    -DJUCE_GENERATE_JUCE_CMAKE=ON

REM 4. Build
cmake --build . --config Release --parallel
```

### Metode 3: CMake Presets (Modern)

Buat `CMakePresets.json`:

```json
{
    "version": 3,
    "configurePresets": [
        {
            "name": "windows-release",
            "hidden": false,
            "generator": "Visual Studio 17 2022",
            "architecture": "x64",
            "binaryDir": "${sourceDir}/build/${presetName}",
            "cacheVariables": {
                "CMAKE_BUILD_TYPE": "Release",
                "JUCE_GENERATE_JUCE_CMAKE": "ON"
            }
        }
    ],
    "buildPresets": [
        {
            "name": "windows-release",
            "configurePreset": "windows-release",
            "configuration": "Release"
        }
    ]
}
```

Build dengan:

```cmake
cmake --preset windows-release
cmake --build --preset windows-release
```

### Output yang Diharapkan

```
Build/MyPlugin_artefacts/
└── Release/
    └── VST3/
        └── MyPlugin.vst3/
            ├── Contents/
            │   └── x86_64-windows/
            │       └── MyPlugin.vst3
            └── MyPlugin.vst3
```

### Install VST3

```batch
REM Copy ke Common VST3 folder
mkdir "C:\Program Files\Common Files\VST3\MyPlugin.vst3"
xcopy /E /I "Build\MyPlugin_artefacts\Release\VST3\MyPlugin.vst3" "C:\Program Files\Common Files\VST3\MyPlugin.vst3"
```

Atau gunakan symbolic link untuk development:

```batch
mklink /D "C:\Program Files\Common Files\VST3\MyPlugin.vst3" "C:\Users\indraqubit\Downloads\Build\MyPlugin_artefacts\Release\VST3\MyPlugin.vst3"
```

---

## Tips Environment Windows yang Lebih Tenang

### 1. Non-aktifkan Windows Search Indexing untuk Build Folder

```powershell
# PowerShell (Administrator)
# Disable indexing untuk build directory
Set-ItemProperty -Path "C:\Users\indraqubit\Downloads\Build" -Name "Attributes" -Value 0x2000

# Atau via GUI:
# Right-click folder > Properties > Advanced > Uncheck "Allow files to have contents indexed"
```

### 2. Tambah Build Folder ke Windows Defender Exclusions

```powershell
# PowerShell (Administrator)
Add-MpPreference -ExclusionPath "C:\Users\indraqubit\Downloads\Build"
Add-MpPreference -ExclusionPath "C:\Users\indraqubit\Downloads\MyPlugin"
```

### 3. Non-aktifkan Superfetch (jika RAM terbatas)

```batch
# Command Prompt (Administrator)
sc config SysMain start= disabled
net stop SysMain
```

### 4. Power Plan: High Performance

```powershell
powercfg /s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
```

### 5. Non-aktifkan Visual Effects

```powershell
# System Properties > Advanced > Performance > Settings > Adjust
SystemPropertiesPerformance.exe
```

### 6. Clean Memory sebelum Build

```powershell
# PowerShell
[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers()
```

### 7. Schedule Build saat Idle

Gunakan Task Scheduler untuk build di malam hari.

### 8. Remote Build via WSL

```bash
# Di WSL, trigger build di Windows
powershell.exe -Command "cd /mnt/c/Users/indraqubit/Downloads; .\\build_juce8_vst3.ps1"
```

Output bisa di-monitor dari Linux.

---

## Troubleshooting

### cl.exe: Command not found

**Penyebab:** Environment tidak di-initialize.

**Solusi:**
```batch
call "C:\Program Files\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
```

### Windows SDK not found

**Penyebab:** Windows SDK tidak terinstall atau path salah.

**Solusi:**
1. Buka Visual Studio Installer
2. Modify installation
3. Add Windows 11 SDK component

### CMake Error: JUCE not found

**Penyebab:** JUCE_PATH di CMakeLists.txt salah.

**Solusi:**
```cmake
# Gunakan path absolut
set(JUCE_PATH "C:/Users/indraqubit/Downloads/JUCE")

# Atau via command line
cmake ..\MyPlugin -DJUCE_PATH="C:/Users/indraqubit/Downloads/JUCE"
```

### Linker Error: LNK1104 cannot open file 'juce.lib'

**Penyebab:** Module libraries tidak ditemukan.

**Solusi:**
```cmake
# Pastikan JUCE modules ditemukan
find_package(JUCE REQUIRED CONFIG)
```

### Build Sangat Lambat

**Solusi:**
1. Gunakan parallel build:
   ```batch
   cmake --build . --parallel
   ```
2. Non-aktifkan real-time scanning Windows Defender
3. Gunakan SSD untuk build directory

### Plugin Crash di DAW

**Solusi:**
1. Check Debug build untuk error messages:
   ```batch
   cmake --build . --config Debug
   ```
2. Install VC++ Redistributable
3. Gunakan Dependency Walker untuk cek missing DLLs

### VST3 tidak terdeteksi di DAW

**Solusi:**
1. Pastikan di Common VST3 folder:
   ```
   C:\Program Files\Common Files\VST3\
   ```
2. Scan ulang plugin di DAW
3. Check .vst3 folder structure:
   ```
   MyPlugin.vst3/
   ├── Contents/
   │   ├── Info.plist
   │   └── x86_64-windows/
   │       └── MyPlugin.vst3 (file executable)
   ```

### MSVC Version Mismatch

**Penyebab:** VS Build Tools version tidak cocok dengan project.

**Solusi:** Update VS Build Tools ke versi terbaru.

---

## FAQ

### Q: Apakah JUCE 8 bisa cross-compile dari Linux?

A: Tidak secara resmi didukung. JUCE 8 memerlukan MSVC dan Windows SDK yang hanya tersedia di Windows.

### Q: Apakah JUCE 7 masih bisa digunakan?

A: Ya, JUCE 7 masih support MinGW cross-compile. Tapi JUCE 8 memiliki fitur Direct2D renderer yang lebih cepat.

### Q: Berapa biaya VS Build Tools?

A: Gratis untuk individual dan open-source projects.

### Q: Apakah perlu Visual Studio IDE?

A: Tidak. Build Tools saja sudah cukup untuk command-line build.

### Q: Plugin yang di-build compatible dengan Windows 10?

A: Ya, JUCE 8 support Windows 10 (1903+) dan Windows 11.

### Q: Bagaimana cara update JUCE?

A:
```batch
cd C:\Users\indraqubit\Downloads\JUCE
git pull origin master
```

### Q: Bisakah build AAX untuk Pro Tools?

A: Ya, tapi memerlukan:
1. Avid SDK (harus beli/agree license)
2. Perubahan konfigurasi
3. Signing certificate

### Q: Cara build Release dan Debug?

A:
```batch
# Release
cmake --build . --config Release

# Debug
cmake --build . --config Debug
```

### Q: Plugin hasil build berapa MB?

A: Tergantung JUCE modules yang digunakan. Range tipikal:
- Minimal: 1-2 MB
- Full-featured: 5-15 MB

### Q: Bagaimana dengan CI/CD?

A: GitHub Actions dengan Windows runner support VS Build Tools:

```yaml
steps:
- uses: actions/checkout@v3
- name: Setup MSVC
  uses: microsoft/setup-msbuild@v1
- name: Configure
  run: cmake -G "Visual Studio 17 2022" -A x64 -B build
- name: Build
  run: cmake --build build --config Release
```

---

## Referensi

- JUCE Official: https://juce.com/
- JUCE Forum: https://forum.juce.com/
- MSVC Documentation: https://docs.microsoft.com/en-us/cpp/
- Steinberg VST3 SDK: https://sdk.steinberg.net/
- VS Build Tools: https://visualstudio.microsoft.com/visual-cpp-build-tools/

---

## Changelog

| Versi | Tanggal | Deskripsi |
|-------|---------|-----------|
| 1.0 | 2025-01-19 | Initial release |

---

**Dokumen ini dibuat dengan bantuan opencode AI Assistant.**
