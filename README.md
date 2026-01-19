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

## Quick Start

### Prerequisites

| Software | Version | Purpose |
|----------|---------|---------|
| Windows 11 | 22H2+ | Host OS |
| Visual Studio Build Tools | 2022 | MSVC Compiler |
| Windows 11 SDK | 10.0.22621.0 | Windows APIs |
| CMake | 3.20+ | Build system |
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

### Real-World Scenarios

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
├── README.md                      # This file
├── CHANGELOG.md                   # Version history
├── LICENSE                        # MIT License
└── CONTRIBUTING.md                # Contribution guidelines
```

## Documentation

- **[Full Guide](JUCE8_VST3_BUILD_GUIDE.md)** - Complete walkthrough with architecture diagrams
- **[Quick Start](README.md)** - Get up and running fast
- **[Troubleshooting](JUCE8_VST3_BUILD_GUIDE.md#troubleshooting)** - Common issues and solutions
- **[Contributing](CONTRIBUTING.md)** - How to help improve this project

## Requirements

### Hardware

- 8 GB RAM (16 GB recommended)
- 10 GB free disk space
- Quad-core CPU (recommended)

### Software

- Windows 11 (64-bit)
- Visual Studio Build Tools 2022
- Windows 11 SDK
- CMake 3.20+
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
- **Modern C++20** - Latest language features
- **Windows 10/11 APIs** - Full platform access
- **Optimized Builds** - LTCG, PGO ready

## Support

- **Issues:** Report problems on GitHub
- **Forum:** [JUCE Forum](https://forum.juce.com/)
- **Docs:** See [JUCE8_VST3_BUILD_GUIDE.md](JUCE8_VST3_BUILD_GUIDE.md)

## License

MIT License - See [LICENSE](LICENSE) for details.

## Credits

Built with assistance from opencode AI Assistant.

---

**Start building JUCE 8 VST3 plugins without the bloat.**
