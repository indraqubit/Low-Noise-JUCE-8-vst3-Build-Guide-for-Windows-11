# Changelog

All notable changes to this project are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-01-19

### Added

- Initial release
- JUCE8_VST3_BUILD_GUIDE.md - Complete documentation (~1000 lines)
- install_vs_buildtools.bat - VS Build Tools silent installer
- build_juce8_vst3.ps1 - PowerShell build script
- CMakeLists.txt.example - Plugin template
- juce8-windows-toolchain.cmake - CMake toolchain
- README.md - Quick start guide

### Features

- Windows build environment setup
- WSL compatibility
- Command-line only workflow
- Minimal footprint (2-3 GB)
- CI/CD ready configuration

### Documentation

- Architecture diagrams
- Step-by-step installation
- Troubleshooting guide
- FAQ section
- Plugin configuration reference

### Technical Details

- Compiler: MSVC v143 (VS 2022 Build Tools)
- SDK: Windows 11 SDK 10.0.22621.0
- Build System: CMake 3.20+
- Plugin Format: VST3

## [Unreleased]

### Planned

- [ ] Example plugin project
- [ ] CI/CD GitHub Actions workflow
- [ ] Debug build configuration
- [ ] Installer script
- [ ] Video tutorial links

## Version History

| Version | Date | Status |
|---------|------|--------|
| 1.0.0 | 2025-01-19 | Released |
| - | - | Working |

## Naming Convention

This project uses semantic versioning: `MAJOR.MINOR.PATCH`

- **MAJOR:** Incompatible changes
- **MINOR:** New features (backward compatible)
- **PATCH:** Bug fixes

## Release Checklist

- [ ] Update CHANGELOG.md
- [ ] Update version in all files
- [ ] Test all scripts
- [ ] Verify documentation
- [ ] Tag release
- [ ] Push to remote
