# Low Noise JUCE 8 vst3 Build Guide for Windows 11

Build professional audio plugins using JUCE 8 from WSL/Windows environment.

## Why This Guide?

JUCE 8 marks a significant shift - Direct2D is now the default renderer, MinGW cross-compile is no longer supported, and MSVC is mandatory for Windows builds. This creates a challenge for developers who prefer lightweight, command-line workflows.

This guide solves that problem by providing the **lightest possible Windows build environment** while maintaining full JUCE 8 compatibility.

## Benefits

### 1. Minimal Disk Footprint

| Solution | Disk Space | Installation Time |
|----------|------------|-------------------|
| Visual Studio Community (Full IDE) | 20-30 GB | 30-60 minutes |
| VS Build Tools (This Guide) | 2-3 GB | 5-10 minutes |
| Savings | **~90% less** | **~80% faster** |

### 2. Silent, Command-Line Only

No noisy IDE, no background services, no automatic updates interrupting your workflow.

```
VS Build Tools = Just compilers and SDK
Visual Studio = IDE + 50+ components + telemetry + background processes
```

### 3. WSL Compatible

Code in your favorite Linux editor (Neovim, VS Code Remote, etc.) while building for Windows:

```
Linux (Coding)  →  /mnt/c/  →  Windows (Building)  →  .vst3
```

> **⚠️ WSL is used for editing and scripting only.** All compilation and linking are performed by **Windows MSVC**, not Linux.

### 4. Production-Ready

The same environment used for builds can be used in CI/CD pipelines:

```yaml
# GitHub Actions example
- name: Build VST3
  run: |
    call "C:\Program Files\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
    cmake --build . --config Release
```

### 5. Clean Separation

Development environment (Linux) stays clean from Windows-specific build tools. No pollution, no conflicts.

## ⚠️ WSL Architecture Clarification

**Important: This guide requires a Windows machine with MSVC installed.**

### What WSL Is Used For

- **Editing:** Use your favorite Linux text editors (Neovim, Emacs, VS Code Remote)
- **Scripting:** Run shell scripts, Git commands, and development utilities
- **File Access:** Access Windows files via `/mnt/c/`

### What WSL Is NOT Used For

- **Compilation:** All building is done by native Windows MSVC compiler, NOT Linux GCC
- **Cross-compilation:** This is NOT a cross-compile setup
- **Linking:** All linking is done by Windows LINK.EXE, NOT Linux ld

### The Build Process

```
┌─────────────────────────────────────────────────┐
│ WSL (Linux)                                     │
│ - Edit source code                              │
│ - Run Git commands                              │
│ - Execute PowerShell scripts via cmd.exe        │
└─────────────────────────────────────────────────┘
                     ↓
┌─────────────────────────────────────────────────┐
│ Windows Native (MSVC)                           │
│ - Compile C++ code                              │
│ - Link binaries                                 │
│ - Generate .vst3 plugins                        │
└─────────────────────────────────────────────────┘
```

### Who This Guide Will NOT Work For

❌ **Pure Linux users (no Windows machine)** - You cannot build Windows VST3 plugins without Windows and MSVC  
❌ **macOS-only developers** - Use Xcode on macOS instead  
❌ **Those expecting Linux-native compilation** - MSVC is mandatory for JUCE 8 Windows builds

### Who This Guide WILL Work For

✅ **Windows users** who want a minimal build environment  
✅ **WSL users on Windows** who prefer Linux tools for editing but need Windows builds  
✅ **Developers** setting up CI/CD on Windows runners  
✅ **Plugin developers** who want command-line workflows

## Quick Start

### Prerequisites

| Software | Version | Purpose |
|----------|---------|---------|
| Windows 11 | 22H2+ | Host OS |
| Visual Studio Build Tools | 2022 | MSVC Compiler |
| Windows 11 SDK | 10.0.22621.0 | Windows APIs |
| CMake | 3.25+ | Build system |
| JUCE | 8.x | Framework |

### Installation

1. **Install Visual Studio Build Tools**
   ```batch
   cd C:\Users\indraqubit\Documents\GitHub\JUCE8_VST3_BUILD_GUIDE_WIN_11
   install_vs_buildtools.bat
   ```

2. **Download JUCE 8**
   ```bash
   git clone https://github.com/juce-framework/JUCE.git
   # Extract to C:\Users\indraqubit\Downloads\JUCE
   ```

3. **Build Your First Plugin**
   ```powershell
   cd C:\Users\indraqubit\Documents\GitHub\JUCE8_VST3_BUILD_GUIDE_WIN_11
   .\build_juce8_vst3.ps1 -PROJECT_PATH "path\to\your\plugin"
   ```

## Who This Is For

### This Guide Is For:

- **Linux/WSL developers** who want to build Windows plugins
- **Plugin developers** tired of heavy IDEs
- **CI/CD engineers** setting up build pipelines
- **Audio developers** who prefer minimal environments
- **Anyone** who wants JUCE 8 on Windows without the bloat

### This Guide Is NOT For:

- Complete beginners (start with JUCE tutorials first)
- macOS-only developers (use Xcode on macOS)
- Those who need Visual Studio debugger (use WinDbg or VS Code)

## Problem This Solves

### The JUCE 8 Challenge

```
JUCE 7 + MinGW  →  Cross-compile from Linux  ✓
JUCE 8 + MinGW  →  Not supported  ✗
JUCE 8 + MSVC   →  Requires Windows + MSVC  ✓ (but how?)
```

**Traditional Solution:** Install 20+ GB Visual Studio
**This Guide:** Install 2-3 GB Build Tools only

### 4 Real-World Scenarios

| Scenario | Traditional Approach | This Guide |
|----------|---------------------|------------|
| WSL developer | Dual-boot or VM | Seamless |
| CI/CD pipeline | Self-hosted runner with VS | Any Windows runner |
| Plugin updates | Interruptive IDE updates | Silent builds |
| Disk space | 30+ GB consumed | 3 GB only |

## Key Features

- **Minimal footprint** - 2-3 GB instead of 20+ GB
- **Command-line only** - No noisy GUI, no telemetry
- **WSL compatible** - Code in Linux, build in Windows
- **CI/CD ready** - Same environment for local and server builds
- **Production-ready** - Identical output to VS builds
- **Well documented** - 1000+ lines of detailed guides

## What's Included

```
JUCE8_VST3_BUILD_GUIDE_WIN_11/
├── JUCE8_VST3_BUILD_GUIDE.md      # Full documentation (1000+ lines)
├── install_vs_buildtools.bat      # Silent installer
├── build_juce8_vst3.ps1           # One-click build script
├── CMakeLists.txt.example         # Production-ready template
├── juce8-windows-toolchain.cmake  # CMake toolchain
├── SCENARIO.md                    # 4 real-world usage scenarios
├── VOLATILITY.md                  # Stability analysis & production risks
├── BENEFITS.md                    # Feature comparison guide
├── BEST_PRACTICES.md              # Production guidelines
├── README.md                      # This file
├── CHANGELOG.md                   # Version history
├── LICENSE                        # MIT License
└── CONTRIBUTING.md                # Contribution guidelines
```

## Documentation

### Core Guides

The full guide ([JUCE8_VST3_BUILD_GUIDE.md](JUCE8_VST3_BUILD_GUIDE.md)) contains 1000+ lines covering:
- [Architecture Overview](JUCE8_VST3_BUILD_GUIDE.md#architecture)
- [Toolchain Configuration](JUCE8_VST3_BUILD_GUIDE.md#toolchain)
- [Installation Steps](JUCE8_VST3_BUILD_GUIDE.md#installation)
- [Build Process](JUCE8_VST3_BUILD_GUIDE.md#build)
- [Troubleshooting](JUCE8_VST3_BUILD_GUIDE.md#troubleshooting)
- [CI/CD Integration](JUCE8_VST3_BUILD_GUIDE.md#cicd)

### Documentation by Use Case

| Document | Purpose |
|----------|---------|
| **[SCENARIO.md](SCENARIO.md)** | 4 real-world scenarios (Indie Dev, WSL Dev, CI/CD Team, Quick Prototyping) |
| **[BENEFITS.md](BENEFITS.md)** | Feature comparison (Traditional vs Low-Noise approach) |
| **[VOLATILITY.md](VOLATILITY.md)** | Stability & production risk analysis (Pure Windows vs WSL) |
| **[BEST_PRACTICES.md](BEST_PRACTICES.md)** | Production guidelines & troubleshooting |

## Requirements

### Hardware

- 8 GB RAM (16 GB recommended)
- 10 GB free disk space
- Quad-core CPU (recommended)

### Software

- Windows 11 (64-bit)
- Visual Studio Build Tools 2022
- Windows 11 SDK
- CMake 3.25+
- JUCE 8.x

## Comparison

### Size Comparison

```
┌─────────────────────────┬────────────┬──────────────────┐
│ Solution                │ Size       │ Noise Level      │
├─────────────────────────┼────────────┼──────────────────┤
│ Visual Studio Full IDE  │ 20-30 GB   │ High (GUI, apps) │
│ VS Build Tools          │ 2-3 GB     │ Low (CLI only)   │
│ This Guide              │ 2-3 GB     │ Minimal (scripts)│
└─────────────────────────┴────────────┴──────────────────┘
```

### Workflow Comparison

| Task | Traditional (VS IDE) | This Guide |
|------|---------------------|------------|
| Initial setup | 30-60 min, many clicks | 5-10 min, one script |
| Daily build | Open IDE, wait load | Run script |
| Memory usage | 2-4 GB constantly | ~100 MB when building |
| Background processes | Dozens | Zero |
| CI/CD integration | Complex | Simple |

## JUCE 8 Features Enabled

This setup unlocks all JUCE 8 Windows features:

- **Direct2D Renderer** - Hardware-accelerated graphics
- **WebView Support** - Embed web-based UIs
- **Modern C++17** (C++20 optional) - Latest language features
- **Windows 10/11 APIs** - Full platform access
- **Optimized Builds** - LTCG, PGO ready

## Debugging

Debugging with this minimal environment requires additional setup:

- **VS Code + C++ Extension** - Can debug MSVC binaries with `cppvsdbg` adapter
- **WinDbg** - Microsoft's advanced debugger (command-line, powerful)
- **Visual Studio IDE** - Optional: install separately if full debugger UI is needed

This guide focuses on **build-only** scenarios. Debugging is intentionally out of scope to maintain the low-noise promise.

## Support

- **Issues:** Report problems on GitHub
- **Forum:** [JUCE Forum](https://forum.juce.com/)
- **Docs:** See [JUCE8_VST3_BUILD_GUIDE.md](JUCE8_VST3_BUILD_GUIDE.md)

## License

MIT License - See [LICENSE](LICENSE) for details.

## Credits

Built with assistance from opencode AI Assistant.

---

## 🇮🇩 Bahasa Indonesia

Repository **Low-Noise-JUCE-8-vst3-Build-Guide-for-Windows-11** adalah panduan lengkap untuk membangun audio VST3 plugins menggunakan JUCE 8 di Windows 11 dengan environment yang minimal dan ringan.

### 🎯 Tujuan Utama

Menyediakan alternatif **ringan dan cepat** untuk membangun JUCE 8 VST3 di Windows tanpa menginstal Visual Studio Community yang besar (20-30 GB).

### 📦 Isi Repository

| File | Tujuan |
|------|--------|
| **README.md** | Pengenalan & quick start guide |
| **JUCE8_VST3_BUILD_GUIDE.md** | Dokumentasi lengkap (1000+ baris) |
| **build_juce8_vst3.ps1** | PowerShell script untuk build otomatis |
| **install_vs_buildtools.bat** | Installer otomatis untuk VS Build Tools |
| **CMakeLists.txt.example** | Template CMake siap produksi |
| **juce8-windows-toolchain.cmake** | Konfigurasi CMake untuk JUCE 8 |
| **CONTRIBUTING.md** | Panduan kontribusi |
| **CHANGELOG.md** | Riwayat perubahan |

### 🚀 Konsep Utama

**Masalah yang Dipecahkan:**
- JUCE 7 → Bisa menggunakan MinGW (cross-compile dari Linux) ✅
- JUCE 8 → Hanya mendukung MSVC, **tidak ada MinGW** ❌
- Solusi tradisional: Install Visual Studio penuh (20-30 GB) 💾

**Solusi Repository:**
Gunakan **VS Build Tools saja** (2-3 GB) tanpa IDE penuh:

| Aspek | Visual Studio Full | VS Build Tools (Guide ini) |
|-------|-------------------|---------------------------|
| Ukuran Disk | 20-30 GB | 2-3 GB (**90% lebih kecil**) |
| Waktu Install | 30-60 menit | 5-10 menit (**80% lebih cepat**) |
| GUI/Noise | Banyak background process | CLI only, zero noise |
| WSL Compatible | Tidak mudah | Yes ✅ |

### 🛠️ Cara Kerja

**1. install_vs_buildtools.bat**
Script Windows batch untuk instalasi otomatis:
- Download & install Visual Studio Build Tools 2022
- Install MSVC compiler & Windows SDK

**2. build_juce8_vst3.ps1**
PowerShell script yang melakukan 4 langkah:
```powershell
[1/4] Inisialisasi VS Build Tools environment
[2/4] Buat build directory
[3/4] Configure dengan CMake
[4/4] Build plugin
```

**3. CMake Toolchain** (juce8-windows-toolchain.cmake)
Konfigurasi untuk membangun dengan MSVC + JUCE 8

### ✨ Fitur Utama

1. **Minimal Footprint** - Hanya 2-3 GB disk space
2. **Command-Line Only** - Tidak ada GUI yang mengganggu
3. **WSL Compatible** - Code di Linux, build di Windows
4. **CI/CD Ready** - Sama dengan environment lokal
5. **Production-Ready** - Output identik dengan VS builds
6. **Well Documented** - 1000+ baris dokumentasi detail

### 👥 Target Pengguna

**Cocok untuk:**
- Developers Linux/WSL yang ingin build plugin Windows
- Plugin developers yang benci IDE berat
- CI/CD engineers
- Audio developers yang prefer minimal environment

**Tidak cocok untuk:**
- Pemula (mulai dari JUCE tutorials dulu)
- macOS developers (pakai Xcode)
- Yang butuh Visual Studio debugger

### 🔗 Workflow Contoh

```
Linux (WSL)                Windows
   ↓                          ↓
Code di VS Code → /mnt/c/ → Build Tools
   ↓                          ↓
Plugin source           MSVC Compiler
                            ↓
                       VST3 Plugin
                            ↓
                      Output ke build/
```

### 📊 Perbandingan Sumber Daya

| Aspek | VS Community | Build Tools + Guide |
|-------|-------------|-------------------|
| Memory usage (idle) | 2-4 GB | ~100 MB |
| Background processes | Puluhan | Zero |
| Setup time | 30-60 min | 5-10 min |
| Workflow | Open IDE → wait | Run script |
| CI/CD fit | Complex | Simple |

---

**Start building JUCE 8 VST3 plugins without the bloat.**
