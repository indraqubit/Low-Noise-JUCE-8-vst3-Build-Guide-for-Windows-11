# JUCE 8 VST3 Best Practices

Production tips and troubleshooting for building professional audio plugins.

---

## 🇮🇩 Bahasa Indonesia

Dokumen ini berisi tips produksi dan troubleshooting untuk membangun audio plugins profesional.

---

## 1. VST3 Output Permissions

### English

When building VST3 plugins, the output is typically placed in `C:\Program Files\Common Files\VST3`. This directory requires administrator write access. If your build fails silently or the plugin doesn't appear in DAWs, check the following:

- Ensure the build script has appropriate permissions
- Run the build as administrator if necessary
- Consider using a local output directory for development, then copy to VST3 folder manually

For CI/CD environments, Windows runners typically have sufficient permissions by default.

### Bahasa Indonesia

Ketika membangun VST3 plugins, output biasanya ditempatkan di `C:\Program Files\Common Files\VST3`. Direktori ini memerlukan akses write administrator. Jika build gagal atau plugin tidak muncul di DAW, periksa:

- Pastikan build script memiliki permissions yang tepat
- Jalankan build sebagai administrator jika perlu
- Pertimbangkan menggunakan local output directory untuk development, lalu copy ke folder VST3 secara manual

Untuk environment CI/CD, Windows runner biasanya sudah memiliki permissions yang cukup secara default.

---

## 2. Advanced Debugging

### English

For debugging VST3 plugins built with this minimal environment:

- **VS Code + C++ Extension**: Can debug MSVC binaries using the `cppvsdbg` adapter. Configure `launch.json` with the target DAW as the executable.
- **WinDbg**: Microsoft's command-line debugger. Powerful for crash analysis but has a steep learning curve.
- **ProcDump**: Useful for capturing crash dumps when issues are hard to reproduce. Run `procdump -ma <pid>` to capture full-memory dumps.
- **juce_vst3_helper.exe**: This helper process may crash during development. Check JUCE forums for known issues and workarounds.

This guide focuses on building only. For production debugging, additional tools are recommended.

### Bahasa Indonesia

Untuk debugging VST3 plugins yang dibangun dengan environment minimal ini:

- **VS Code + C++ Extension**: Bisa debug MSVC binaries menggunakan adapter `cppvsdbg`. Configure `launch.json` dengan target DAW sebagai executable.
- **WinDbg**: Debugger command-line dari Microsoft. Powerful untuk crash analysis tapi learning curve yang curam.
- **ProcDump**: Berguna untuk menangkap crash dumps ketika masalah sulit direproduksi. Jalankan `procdump -ma <pid>` untuk capture full-memory dumps.
- **juce_vst3_helper.exe**: Process helper ini mungkin crash selama development. Cek JUCE forums untuk known issues dan workarounds.

Guide ini fokus ke build saja. Untuk production debugging, tools tambahan direkomendasikan.

---

## 3. Production Packaging

### English

For distributing your VST3 plugin to users:

- **NSIS (Nullsoft Scriptable Install System)**: Recommended for most indie developers. Simple, scriptable, and produces small installers. Create a minimal NSIS script that copies the `.vst3` folder to the correct location.
- **WiX Toolset**: For enterprise distributions requiring MSI packages. More complex but supports silent installs and enterprise deployment policies. Use only if your distribution requirements demand it.
- **Code Signing**: Always sign your installer and binaries to avoid SmartScreen warnings. Use an EV code signing certificate for best results.

Start with NSIS. Only consider WiX if you have specific enterprise requirements.

### Bahasa Indonesia

Untuk mendistribusikan VST3 plugin ke users:

- **NSIS (Nullsoft Scriptable Install System)**: Direkomendasikan untuk kebanyakan indie developers. Simple, scriptable, dan menghasilkan installer kecil. Buat NSIS script minimal yang mengcopy folder `.vst3` ke lokasi yang benar.
- **WiX Toolset**: Untuk distribusi enterprise yang memerlukan paket MSI. Lebih kompleks tapi mendukung silent installs dan deployment policies enterprise. Gunakan hanya jika requirements distribusi membutuhkannya.
- **Code Signing**: Selalu sign installer dan binaries untuk menghindari SmartScreen warnings. Gunakan EV code signing certificate untuk hasil terbaik.

Mulai dengan NSIS. Pertimbangkan WiX hanya jika ada specific enterprise requirements.

---

## 4. Testing Workflow

### English

Before releasing your plugin, test across multiple environments:

- **Multi-DAW Testing**: Test your plugin in at least 2-3 DAWs (Reaper, Ableton Live, Cubase, FL Studio). Each DAW has different plugin loading behaviors.
- **AudioPluginHost**: Use JUCE's AudioPluginHost for initial testing. It provides a clean environment to verify basic functionality.
- **Format Compatibility**: Ensure VST3 format works correctly. Consider providing CLAP format as an alternative for better cross-DAW compatibility.
- **Resource Cleanup**: Test plugin loading/unloading cycles to ensure no memory leaks or resource orphans.

Basic testing is essential. Comprehensive testing with multiple DAWs is recommended before release.

### Bahasa Indonesia

Sebelum merelease plugin, test di multiple environments:

- **Multi-DAW Testing**: Test plugin di minimal 2-3 DAWs (Reaper, Ableton Live, Cubase, FL Studio). Setiap DAW memiliki plugin loading behaviors yang berbeda.
- **AudioPluginHost**: Gunakan AudioPluginHost dari JUCE untuk initial testing. Memberikan environment clean untuk verify basic functionality.
- **Format Compatibility**: Pastikan format VST3 bekerja dengan benar. Pertimbangkan menyediakan format CLAP sebagai alternatif untuk cross-DAW compatibility yang lebih baik.
- **Resource Cleanup**: Test plugin loading/unloading cycles untuk memastikan tidak ada memory leaks atau resource orphans.

Basic testing itu essential. Comprehensive testing dengan multiple DAWs direkomendasikan sebelum release.

---

## 5. Error Handling

### English

Robust error handling in your build process:

- **Build Logging**: Redirect all build output to a log file. This makes troubleshooting easier and provides an audit trail.
- **Fail-Fast Behavior**: The build script should exit immediately on errors. Do not continue past compilation failures.
- **Error Codes**: Use proper exit codes (0 for success, non-zero for failures) to integrate with CI/CD systems.
- **Artifact Verification**: After build, verify that the `.vst3` folder was created and contains expected files before marking the build as successful.

These practices ensure reliable, reproducible builds.

### Bahasa Indonesia

Robust error handling di build process:

- **Build Logging**: Redirect semua build output ke log file. Ini membuat troubleshooting lebih mudah dan menyediakan audit trail.
- **Fail-Fast Behavior**: Build script harus exit immediately on errors. Jangan lanjutkan setelah compilation failures.
- **Error Codes**: Gunakan exit codes yang proper (0 untuk success, non-zero untuk failures) untuk integrasi dengan CI/CD systems.
- **Artifact Verification**: Setelah build, verifikasi bahwa folder `.vst3` sudah dibuat dan contains expected files sebelum menandai build sebagai successful.

Practices ini memastikan builds yang reliable dan reproducible.

---

## 6. CI/CD Examples

### English

GitHub Actions is the recommended CI/CD platform for JUCE 8 VST3 projects:

**Basic Build Workflow:**

```yaml
name: Build VST3

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup MSVC
        uses: egor-tensin/vs-setup@v4

      - name: Configure CMake
        run: cmake -B build -DCMAKE_BUILD_TYPE=Release

      - name: Build
        run: cmake --build build --config Release --parallel
```

**Release Workflow (Modern):**

```yaml
name: Release VST3

on:
  push:
    tags:
      - 'v*'

jobs:
  release:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup MSVC
        uses: egor-tensin/vs-setup@v4

      - name: Build Plugin
        run: |
          cmake -B build -DCMAKE_BUILD_TYPE=Release
          cmake --build build --config Release --parallel

      - name: Package Artifacts
        run: |
          Compress-Archive -Path "build/VST3/*.vst3" -DestinationPath plugin-windows.zip

      - name: Create Release
        uses: softprops/action-gh-release@v2
        with:
          files: plugin-windows.zip
          generate_release_notes: true
```

These workflows run on Windows runners with MSVC pre-installed. Builds take ~5-10 minutes. The release workflow uses modern GitHub Actions (`softprops/action-gh-release@v2`) instead of deprecated `actions/create-release@v1` and `actions/upload-release-asset@v1`.

### Bahasa Indonesia

GitHub Actions adalah platform CI/CD yang direkomendasikan untuk proyek JUCE 8 VST3:

**Workflow Build Dasar:**

```yaml
name: Build VST3

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup MSVC
        uses: egor-tensin/vs-setup@v4

      - name: Configure CMake
        run: cmake -B build -DCMAKE_BUILD_TYPE=Release

      - name: Build
        run: cmake --build build --config Release --parallel
```

**Workflow Release (Modern):**

```yaml
name: Release VST3

on:
  push:
    tags:
      - 'v*'

jobs:
  release:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup MSVC
        uses: egor-tensin/vs-setup@v4

      - name: Build Plugin
        run: |
          cmake -B build -DCMAKE_BUILD_TYPE=Release
          cmake --build build --config Release --parallel

      - name: Package Artifacts
        run: |
          Compress-Archive -Path "build/VST3/*.vst3" -DestinationPath plugin-windows.zip

      - name: Create Release
        uses: softprops/action-gh-release@v2
        with:
          files: plugin-windows.zip
          generate_release_notes: true
```

Workflow ini berjalan di Windows runners dengan MSVC pre-installed. Build memakan waktu ~5-10 menit. Workflow release menggunakan GitHub Actions modern (`softprops/action-gh-release@v2`) sebagai pengganti dari `actions/create-release@v1` dan `actions/upload-release-asset@v1` yang sudah deprecated.

---

## Summary

| Practice | Recommendation |
|----------|----------------|
| CI/CD | GitHub Actions (Windows runners) |
| Packaging | NSIS for installers |
| Debugging | VS Code, WinDbg, or ProcDump |
| Testing | Multi-DAW validation |

---

**This guide focuses on build infrastructure. For full production release workflows, consider additional steps for marketing, distribution, and user support.**
