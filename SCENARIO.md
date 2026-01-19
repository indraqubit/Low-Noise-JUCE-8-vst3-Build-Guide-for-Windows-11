## 🎯 **SKENARIO PENGGUNAAN LENGKAP**

Saya akan tunjukkan 3 skenario berbeda dengan step-by-step instructions:

---

## **SKENARIO 1: Audio Plugin Developer (Indie)**

### 👤 **Profile:**
- Seorang indie developer ingin membuat plugin VST3
- Laptop Windows 11, code di VS Code
- Ingin build process yang cepat & ringan
- Tidak ingin VS Community (terlalu berat)

### 📋 **Alur Kerjanya:**

```
START
  ↓
[Day 0] Persiapan
  ├─ Install VS Build Tools (2-3 GB, 10 menit)
  ├─ Download JUCE 8 (500 MB)
  └─ Clone repo guide ini
  ↓
[Day 1] Membuat Plugin
  ├─ Buat folder MyPlugin/ dengan CMakeLists.txt
  ├─ Write C++ code di Source/ folder
  ├─ Edit CMakeLists.txt dengan metadata plugin
  └─ Git commit
  ↓
[Daily] Build & Test
  ├─ Edit code di VS Code (di WSL atau native Windows)
  ├─ Run:  .\build_juce8_vst3.ps1 -PROJECT_PATH ".\MyPlugin"
  ├─ Check output: Build/MyPlugin. vst3
  ├─ Copy ke:  C:\Program Files\Common Files\VST3\
  ├─ Open DAW (Reaper/Cubase), test plugin
  └─ If crash → Fix code → rebuild
  ↓
[Release] Packaging
  ├─ Create NSIS installer (pakai template)
  ├─ Code sign binary
  ├─ Test di berbagai DAW (BEST_PRACTICES. md → Testing Workflow)
  └─ Upload ke gumroad/itch.io
  ↓
END
```

### 🔧 **Command-by-Command:**

#### **Setup (1 kali)**
```powershell
# 1. Download guide repository
git clone https://github.com/indraqubit/Low-Noise-JUCE-8-vst3-Build-Guide-for-Windows-11.git
cd Low-Noise-JUCE-8-vst3-Build-Guide-for-Windows-11

# 2. Install VS Build Tools
.\install_vs_buildtools.bat

# 3. Download JUCE 8
cd C:\Users\YourName\Downloads
git clone https://github.com/juce-framework/JUCE.git
```

#### **Hari Pertama:  Create Plugin**
```bash
# 1. Buat folder plugin (di WSL atau Windows)
mkdir MySimplePlugin
cd MySimplePlugin

# 2. Copy template CMakeLists.txt
cp ../CMakeLists.txt. example CMakeLists.txt

# 3. Edit CMakeLists.txt:
#    - Ganti "MyPlugin" → "MySimplePlugin"
#    - Ganti manufacturer code:  "InDq" (registrasi di Steinberg)
#    - Ganti plugin code: "Simp"
```

#### **Folder Structure**
```
MySimplePlugin/
├── CMakeLists. txt
├── Source/
│   ├── PluginProcessor.cpp
│   ├── PluginProcessor.h
│   ├── PluginEditor.cpp
│   └── PluginEditor.h
└── README.md
```

#### **Setiap Hari:  Build & Test**
```powershell
# Open PowerShell as Administrator
cd C:\Users\YourName\Downloads\Low-Noise-JUCE-8-vst3-Build-Guide-for-Windows-11

# Build
.\build_juce8_vst3.ps1 `
    -JUCE_PATH "C:\Users\YourName\Downloads\JUCE" `
    -PROJECT_PATH "C:\Users\YourName\Projects\MySimplePlugin" `
    -OUTPUT_PATH "C:\Users\YourName\Projects\MySimplePlugin\build" `
    -PLUGIN_NAME "MySimplePlugin"

# Output akan di: MySimplePlugin/build/MySimplePlugin_artefacts/Release/VST3/

# Install ke DAW
$vst3_path = "C:\Program Files\Common Files\VST3\MySimplePlugin.vst3"
Copy-Item "C:\Users\YourName\Projects\MySimplePlugin\build\MySimplePlugin_artefacts\Release\VST3\MySimplePlugin.vst3" -Destination $vst3_path -Recurse -Force

# Open Reaper, rescan plugins → MySimplePlugin muncul! 
```

#### **Saat Release**
```powershell
# 1. Build Release dengan optimization
cmake --build build --config Release

# 2. Create installer (gunakan NSIS)
# - Copy NSIS template dari BEST_PRACTICES.md
# - Modify untuk plugin Anda
# - Build installer:  makensis MySimplePlugin-installer.nsi

# 3. Sign binary
# - Pakai EV code signing cert (dari Digicert, etc)
# - signtool.exe sign /f cert.pfx MySimplePlugin.vst3

# 4. Upload
# - gumroad.com → upload installer
# - itch.io → upload executable
```

### 📊 **Timeline:**
| Fase | Waktu | Effort |
|------|-------|--------|
| Setup | 1-2 jam | Medium (instalasi tools) |
| Development | 1-4 minggu | Tergantung kompleksitas |
| Testing | 2-3 hari | Ringan (pakai BEST_PRACTICES) |
| Release | 1 hari | Light (NSIS template ready) |

---

## **SKENARIO 2: WSL Developer (Cross-Platform)**

### 👤 **Profile:**
- Developer yang prefer Linux environment
- Bekerja di WSL (Ubuntu 22.04)
- Build untuk Windows VST3
- Coding di Neovim, code sync via /mnt/c/

### 📋 **Alur Kerjanya:**

```
WSL (Linux) Environment
    ├─ Neovim / VS Code Remote
    ├─ Git version control
    └─ Source code editing
         │
         ▼
/mnt/c/Users/YourName/Projects/
    │
    ├─ MyPlugin/
    │   ├── CMakeLists.txt
    │   └── Source/ (edited in Neovim)
    │
    └─ JUCE/
         │
         ▼ (via PowerShell from WSL)
         │
    Windows Environment
        ├─ MSVC Compiler
        ├─ Windows SDK
        └─ VS Build Tools
         │
         ▼
    MyPlugin. vst3 (output)
```

### 🔧 **Command-by-Command:**

#### **Setup in WSL**
```bash
# 1. Clone guide repo
git clone https://github.com/indraqubit/Low-Noise-JUCE-8-vst3-Build-Guide-for-Windows-11.git
cd Low-Noise-JUCE-8-vst3-Build-Guide-for-Windows-11

# 2. Symlink ke /mnt/c untuk access dari Windows
ln -s /mnt/c/Users/YourName/Projects ~/win_projects

# 3. Create project structure
mkdir -p ~/win_projects/MyPlugin/Source
```

#### **Daily Development (WSL)**
```bash
# Edit code in Neovim
cd ~/win_projects/MyPlugin
nvim Source/PluginProcessor.cpp

# Version control
git add .
git commit -m "Add compressor logic"

# When ready to build, trigger Windows build
powershell. exe -Command "cd /mnt/c/Users/YourName/Projects; .\\. .\Low-Noise-JUCE-8-vst3-Build-Guide-for-Windows-11\\build_juce8_vst3.ps1"

# Monitor build output from WSL
watch -n 1 'ls -lah /mnt/c/Users/YourName/Projects/MyPlugin/build/'

# Once built, load in DAW for testing
```

#### **Workflow Optimization**
```bash
# Create alias untuk quick build
cat >> ~/.bashrc << 'EOF'
build_vst3() {
  powershell.exe -Command "cd /mnt/c/Users/YourName/Projects/$1; \
  . \\.. \\Low-Noise-JUCE-8-vst3-Build-Guide-for-Windows-11\\build_juce8_vst3.ps1"
}
alias build-plugin='build_vst3'
EOF

# Usage: 
# cd ~/win_projects/MyPlugin
# build-plugin MyPlugin
```

#### **Continuous Rebuild (Watch Mode)**
```bash
# Install watchman atau entr
sudo apt-get install entr

# Auto-rebuild saat ada perubahan
find Source/ -name "*.cpp" -o -name "*.h" | entr -r powershell.exe -Command "cd /mnt/c/.. .; .\\build_juce8_vst3.ps1"
```

### 📊 **Keuntungan WSL Setup:**
- ✅ Code di Linux environment (cleaner, faster editor)
- ✅ Build di Windows (native MSVC)
- ✅ Same files accessible dari keduanya
- ✅ Git history clean
- ✅ No dual-boot needed

---

## **SKENARIO 3: CI/CD Pipeline (GitHub Actions)**

### 👤 **Profile:**
- Team yang develop plugin di GitHub
- Ingin automated builds pada setiap push
- Generate artifacts untuk testing & distribution
- Release management otomatis

### 📋 **GitHub Actions Workflow:**

#### **File:  `.github/workflows/build-vst3.yml`**
```yaml
name: Build JUCE 8 VST3 Plugin

on:
  push: 
    branches: [main, develop]
  pull_request: 
    branches: [main]
  release:
    types: [created]

jobs:
  build: 
    runs-on: windows-latest
    
    steps: 
      # 1. Checkout code
      - uses: actions/checkout@v4
      
      # 2. Setup MSVC via egor-tensin/vs-setup
      - name: Setup MSVC
        uses: egor-tensin/vs-setup@v4
        with:
          arch: x64
      
      # 3. Checkout JUCE as submodule
      - name:  Checkout JUCE
        uses:  actions/checkout@v4
        with:
          repository: juce-framework/JUCE
          path: JUCE
          ref: 8.x  # Use JUCE 8.x branch
      
      # 4. Create build directory
      - name: Create Build Directory
        run: mkdir -p build
      
      # 5. Configure CMake
      - name: Configure CMake
        working-directory: build
        run:  |
          cmake ..  `
            -G "Visual Studio 17 2022" `
            -A x64 `
            -DCMAKE_BUILD_TYPE=Release `
            -DJUCE_PATH="../JUCE"
      
      # 6. Build
      - name: Build Plugin
        working-directory: build
        run: cmake --build .  --config Release --parallel
      
      # 7. Verify Output
      - name: Verify VST3 Output
        run: |
          $vst3_path = Get-ChildItem -Path "build" -Filter "*. vst3" -Recurse
          if ($vst3_path.Count -eq 0) {
            Write-Error "No VST3 file found!"
            exit 1
          }
          Write-Output "✓ VST3 generated:  $($vst3_path. FullName)"
      
      # 8. Upload Artifact (for PR testing)
      - name: Upload Artifact
        uses: actions/upload-artifact@v3
        with:
          name: MyPlugin-vst3
          path: build/**/Release/VST3/*. vst3
          retention-days: 7
      
      # 9. Code Signing (for Release only)
      - name: Code Sign Plugin
        if: startsWith(github.ref, 'refs/tags/')
        run: |
          # Decode cert from secret
          [System.Convert]::FromBase64String("${{ secrets.CODESIGN_CERT_BASE64 }}") | `
            Set-Content -Path cert.pfx -AsByteStream
          
          # Sign all VST3 files
          Get-ChildItem -Path "build" -Filter "*.vst3" -Recurse | ForEach-Object {
            & "C:\Program Files\Microsoft Visual Studio\2022\BuildTools\VC\Tools\LLVM\bin\signtool.exe" `
              sign /f cert.pfx /p "${{ secrets.CODESIGN_CERT_PASSWORD }}" `
              /t "http://timestamp.digicert.com" `
              "$($_. FullName)"
          }
      
      # 10. Create Release Asset
      - name: Create Release
        if: startsWith(github.ref, 'refs/tags/')
        uses: actions/create-release@v1
        env:
          GITHUB_TOKEN: ${{ secrets. GITHUB_TOKEN }}
        with:
          tag_name: ${{ github.ref }}
          release_name: Release ${{ github. ref }}
          draft: false
          prerelease: false
      
      # 11. Upload to Release
      - name: Upload Release Asset
        if: startsWith(github.ref, 'refs/tags/')
        uses: actions/upload-release-asset@v1
        env: 
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          upload_url: ${{ steps.create_release.outputs.upload_url }}
          asset_path: ./build/**/Release/VST3/*.vst3
          asset_name:  MyPlugin-${{ github.ref_name }}. vst3
          asset_content_type: application/octet-stream
```

#### **Secrets yang Diperlukan (Settings > Secrets):**
```yaml
CODESIGN_CERT_BASE64: <base64 encoded . pfx file>
CODESIGN_CERT_PASSWORD: <cert password>
```

#### **Trigger Workflow:**
```bash
# 1. Push ke main → builds & uploads artifact
git push origin main

# 2. Create tag → builds, signs, creates release
git tag v1.0.0
git push origin v1.0.0
```

### 📊 **CI/CD Benefits:**
| Benefit | How It Works |
|---------|------------|
| ✅ Automated Builds | Every commit → automatic build |
| ✅ Early Bug Detection | PR builds fail before merge |
| ✅ Release Ready | Tag creation → auto sign & release |
| ✅ No Local Build Needed | Get artifacts from Actions |
| ✅ Cross-team Testing | Share artifacts easily |

---

## **SKENARIO 4: Quick Prototyping**

### 👤 **Profile:**
- Audio developer yang ingin cepat test ide
- Minimal setup, minimal config
- "Just want to build something fast"

### ⚡ **Quick Start (5 menit):**

```powershell
# 1. Download everything (di mana saja)
cd Downloads
git clone https://github.com/indraqubit/Low-Noise-JUCE-8-vst3-Build-Guide-for-Windows-11.git
git clone https://github.com/juce-framework/JUCE. git
.\Low-Noise-JUCE-8-vst3-Build-Guide-for-Windows-11\install_vs_buildtools.bat

# 2. Copy template
Copy-Item CMakeLists.txt.example MyQuickPlugin\CMakeLists.txt
mkdir MyQuickPlugin\Source

# 3. Create minimal plugin (PluginProcessor.cpp - just pass-through)
# 4. Build
.\build_juce8_vst3.ps1 -PROJECT_PATH .\MyQuickPlugin

# 5. Test in DAW → Done!  ✓
```

### 🎯 **Output:**
```
5 minutes later: 
  MyQuickPlugin. vst3 → Load di Reaper/Cubase → Sound muncul ✓
```

---

## **SKENARIO COMPARISON TABLE**

| Aspek | Indie Dev | WSL Dev | CI/CD Team | Prototyper |
|-------|-----------|---------|-----------|-----------|
| **Setup Time** | 30 menit | 45 menit | 1 jam | 5 menit |
| **Build Frequency** | Daily | Daily | Auto |  One-off |
| **Testing** | Manual | Manual | Automated | Manual |
| **Distribution** | Manual upload | Manual upload | Auto release | No dist |
| **Collaboration** | Single dev | Single dev | Whole team | Solo |
| **Complexity** | Medium | Medium | High | Low |
| **Best For** | Indie releases | Linux devs | Commercial | Learning |

---

## 📌 **KEY TAKEAWAY**

Repo ini memberikan: 

```
┌─────────────────────────────────────────────┐
│  Setup Scripts (install, build)             │
├─────────────────────────────────────────────┤
│  Dokumentasi (15,000+ baris)                │
├─────────────────────────────────────────────┤
│  Best Practices (production checklist)      │
├─────────────────────────────────────────────┤
│  Examples (CMakeLists, CI/CD, packaging)    │
└─────────────────────────────────────────────┘
       ↓ HASILNYA ↓
  VST3 Plugin yang Production-Ready! 
```

**Bisa digunakan untuk:**
- ✅ Indie developer (cepat, ringan, cheap)
- ✅ WSL developers (Linux coding + Windows build)
- ✅ CI/CD teams (automated everything)
- ✅ Prototyping (super fast minimal setup)
- ✅ Learning (lengkap dokumentasinya)

Mau saya jelaskan detail salah satu skenario?  Atau ada pertanyaan spesifik?  🚀