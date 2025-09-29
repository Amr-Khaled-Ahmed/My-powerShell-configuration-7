# 🚀 ZeroAccess PowerShell Configuration

![PowerShell](https://img.shields.io/badge/PowerShell-7+-blue.svg)
![Oh My Posh](https://img.shields.io/badge/Oh%20My%20Posh-Custom%20Themes-green.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

![PowerShell Configuration Screenshot](images/Screenshot%202025-09-29%20213508.png)

A comprehensive and highly customized PowerShell 7+ configuration profile designed for maximum productivity, beautiful aesthetics, and powerful functionality. Transform your Windows terminal into a professional development environment! ✨

## 📋 Table of Contents

- [🌟 Features](#-features)
- [🚀 Quick Start](#-quick-start)
- [📦 Prerequisites](#-prerequisites)
- [⚙️ Installation](#️-installation)
- [🎨 Customization](#-customization)
- [🔧 Functions & Aliases](#-functions--aliases)
- [🐍 Python Tools](#-python-tools)
- [🛠️ Modules](#️-modules)
- [🎯 Usage Examples](#-usage-examples)
- [🔍 Detailed Features](#-detailed-features)
- [🐛 Troubleshooting](#-troubleshooting)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)

## 🌟 Features

### 🎨 **Visual Enhancements**
- **Oh My Posh Integration** - Beautiful, informative command line prompts
- **Multiple Themes** - Switch between themes with interactive FZF selection
- **Terminal Icons** - Visual file type indicators
- **Syntax Highlighting** - Color-coded command output

### ⚡ **Productivity Boosters**
- **FZF Integration** - Fuzzy finding for commands, history, and files
- **PSReadLine** - Enhanced command line editing with predictions
- **Git Integration** - Comprehensive Git helpers and workflows
- **Intelligent Tab Completion** - Context-aware suggestions

### 🔧 **Comprehensive Toolset**
- **200+ Custom Functions** - Covering development, system admin, and DevOps
- **Cross-Platform Support** - Works on Windows, Linux, and macOS
- **Module Management** - Automatic loading of optional modules
- **Error Handling** - Robust error handling and user feedback

### 🛡️ **System Management**
- **Network Diagnostics** - Complete network information and troubleshooting
- **Process Management** - Advanced process monitoring and control
- **System Maintenance** - Automated cleanup and optimization
- **Security Tools** - Password strength testing and file integrity checks

## 🚀 Quick Start

### 1. **Clone the Repository**
```powershell
git clone https://github.com/Amr-Khaled-Ahmed/My-powerShell-configuration-7.git
cd My-powerShell-configuration-7
```

### 2. **Backup Existing Profile** (Recommended)
```powershell
Copy-Item $PROFILE "$PROFILE.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
```

### 3. **Install the Profile**
```powershell
Copy-Item .\Microsoft.PowerShell_profile.ps1 $PROFILE -Force
```

### 4. **Reload PowerShell**
```powershell
. $PROFILE
```

## 📦 Prerequisites

### **Required Software**
- **PowerShell 7+** - [Download here](https://github.com/PowerShell/PowerShell/releases)
- **Oh My Posh** - Beautiful prompt engine
- **FZF** - Fuzzy finder for interactive selection

### **Install Prerequisites**
```powershell
# Install PowerShell 7
winget install Microsoft.PowerShell

# Install Oh My Posh
winget install JanDeDobbeleer.OhMyPosh -s winget

# Install FZF
winget install fzf
```

## ⚙️ Installation

### **Step-by-Step Setup**

1. **Ensure PowerShell Execution Policy Allows Scripts**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

2. **Install Required Modules**
```powershell
# Core modules
Install-Module -Name PSReadLine -AllowPrerelease -Force
Install-Module -Name Terminal-Icons -Force
Install-Module -Name PSFzf -Force

# Optional but recommended
Install-Module -Name posh-git -Force
Install-Module -Name Z -Force
```

3. **Apply the Configuration**
```powershell
# Start a new PowerShell session or reload profile
. $PROFILE
```

## 🎨 Customization

### **Changing Themes**
Use the interactive theme switcher:
```powershell
theme
```

This opens an FZF interface to browse and select from all available Oh My Posh themes.

### **Customizing Functions**
Edit the profile directly:
```powershell
code $PROFILE
```

### **Adding Your Own Aliases**
Add to the profile:
```powershell
function my-alias { ... }
Set-Alias -Name ma -Value my-alias
```

## 🔧 Functions & Aliases

### 🎯 **Core Navigation**
| Command | Description | Example |
|---------|-------------|---------|
| `l` | List files | `l` |
| `la` | List all files (including hidden) | `la` |
| `ll` | List with details | `ll` |
| `lsr` | List recursively | `lsr ~/projects` |
| `which` | Find command location | `which git` |

### 🔍 **File Operations**
| Command | Description | Example |
|---------|-------------|---------|
| `Find-File` | Search files by pattern | `Find-File "config"` |
| `Find-InFile` | Search text in files | `Find-InFile "TODO"` |
| `Compare-Directories` | Compare folder contents | `Compare-Directories dir1 dir2` |
| `Sync-Directories` | Sync folders | `Sync-Directories src dest` |

### 🌐 **Network Tools**
| Command | Description | Example |
|---------|-------------|---------|
| `Get-NetworkInfo` | Comprehensive network info | `Get-NetworkInfo -Detailed` |
| `netinfo` | Network adapter info | `netinfo` |
| `ports` | Open ports | `ports` |
| `Test-Ports` | Test remote ports | `Test-Ports google.com 80,443` |

### 🐳 **Docker & Kubernetes**
| Command | Description | Example |
|---------|-------------|---------|
| `docker-clean` | Clean Docker system | `docker-clean` |
| `docker-stats` | Container statistics | `docker-stats` |
| `k8s-status` | Kubernetes status | `k8s-status -All` |
| `k8s-cleanup` | Clean up K8s resources | `k8s-cleanup` |

### 🔧 **System Information**
| Command | Description | Example |
|---------|-------------|---------|
| `sysinfo` | System information | `sysinfo` |
| `cpuinfo` | CPU details | `cpuinfo` |
| `raminfo` | Memory information | `raminfo` |
| `check-disk` | Disk usage | `check-disk` |

### 📦 **Package Management**
| Command | Description | Example |
|---------|-------------|---------|
| `install` | Universal installer | `install nodejs` |
| `update` | Update packages | `update winget` |
| `venv` | Python virtual env | `venv myproject` |
| `venv-save` | Save requirements | `venv-save` |

### 🔐 **Security Tools**
| Command | Description | Example |
|---------|-------------|---------|
| `Test-PasswordStrength` | Password analysis | `Test-PasswordStrength "MyPass123!"` |
| `Get-FileHash256` | File integrity | `Get-FileHash256 file.exe` |
| `ssh-config` | SSH configuration | `ssh-config add myserver` |

### ⚡ **Development**
| Command | Description | Example |
|---------|-------------|---------|
| `Start-DevEnvironment` | Start dev environment | `Start-DevEnvironment web` |
| `New-Project` | Create new project | `New-Project myapp web` |
| `Build-And-Run` | C++ build helper | `Build-And-Run -Clean` |
| `git-menu` | Interactive Git | `git-menu` |

## 🐍 Python Tools Collection

The repository includes a collection of standalone Python utilities located in the `/python/` directory. These are CLI applications and system tools that complement your PowerShell environment.

### 📁 Available Python Tools

| Tool | Description | Type | Usage |
|------|-------------|------|--------|
| **`drawlogo.py`** | Creates graphical logos and designs | CLI Application | Graphic design and logo creation |
| **`networkTools.py`** | Network scanning and analysis tools | System Utility | Network diagnostics and monitoring |
| **`task bar.py`** | Taskbar customization and management | CLI Application | Windows taskbar manipulation |
| **`taskmanager.py`** | Enhanced task manager interface | CLI Application | Process management |
| **`video_downloader.py`** | Download videos from various platforms | Utility | Media content downloading |
| **`wifi detector.py`** | WiFi network detection and analysis | System Utility | Wireless network scanning |

### 🚀 Running Python Tools

Each Python tool is a standalone script that can be run directly:

```powershell
# Navigate to python tools directory
cd python

# Run individual tools
python drawlogo.py
python networkTools.py
python "task bar.py"
python taskmanager.py
python video_downloader.py
python "wifi detector.py"
```

### 🔧 PowerShell Integration Functions

Add these convenience functions to your PowerShell profile for easy access to Python tools:

```powershell
# Python Tools Launcher Functions
function Start-PythonTool {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ToolName
    )
    
    $repoRoot = Split-Path $PROFILE
    $pythonToolsPath = Join-Path $repoRoot "python"
    
    switch ($ToolName.ToLower()) {
        "drawlogo" { 
            $toolPath = Join-Path $pythonToolsPath "drawlogo.py"
        }
        "networktools" {
            $toolPath = Join-Path $pythonToolsPath "networkTools.py"
        }
        "taskbar" {
            $toolPath = Join-Path $pythonToolsPath "task bar.py"
        }
        "taskmanager" {
            $toolPath = Join-Path $pythonToolsPath "taskmanager.py"
        }
        "videodownloader" {
            $toolPath = Join-Path $pythonToolsPath "video_downloader.py"
        }
        "wifidetector" {
            $toolPath = Join-Path $pythonToolsPath "wifi detector.py"
        }
        default {
            Write-Error "Unknown Python tool: $ToolName"
            return
        }
    }
    
    if (Test-Path $toolPath) {
        Write-Host "Starting $ToolName..." -ForegroundColor Green
        python $toolPath
    } else {
        Write-Error "Python tool not found: $toolPath"
    }
}

# Individual tool functions
function Start-LogoDesigner {
    Start-PythonTool -ToolName "drawlogo"
}

function Start-NetworkTools {
    Start-PythonTool -ToolName "networktools"
}

function Start-TaskBarManager {
    Start-PythonTool -ToolName "taskbar"
}

function Start-TaskManager {
    Start-PythonTool -ToolName "taskmanager"
}

function Start-VideoDownloader {
    Start-PythonTool -ToolName "videodownloader"
}

function Start-WiFiDetector {
    Start-PythonTool -ToolName "wifidetector"
}

# Aliases for quick access
Set-Alias -Name pydesign -Value Start-LogoDesigner
Set-Alias -Name pynetwork -Value Start-NetworkTools
Set-Alias -Name pytaskbar -Value Start-TaskBarManager
Set-Alias -Name pytaskmgr -Value Start-TaskManager
Set-Alias -Name pydownload -Value Start-VideoDownloader
Set-Alias -Name pywifi -Value Start-WiFiDetector
```

### 🎯 Usage Examples

```powershell
# Start logo designer
Start-LogoDesigner
# or use alias
pydesign

# Launch network tools
Start-NetworkTools
pynetwork

# Open task manager
Start-TaskManager
pytaskmgr

# Start video downloader
Start-VideoDownloader
pydownload

# Launch WiFi detector
Start-WiFiDetector
pywifi
```

### 📋 Tool Descriptions

#### **Logo Designer** (`pydesign`)
- **Purpose**: Graphic design and logo creation
- **Features**: CLI-based logo design tools
- **Usage**: Run and use the graphical interface to create designs

#### **Network Tools** (`pynetwork`)
- **Purpose**: Network scanning and diagnostics
- **Features**: Various network analysis utilities
- **Usage**: CLI interface for network operations

#### **Taskbar Manager** (`pytaskbar`)
- **Purpose**: Windows taskbar customization
- **Features**: Taskbar manipulation and management
- **Usage**: Graphical interface for taskbar settings

#### **Task Manager ** (`pytaskmgr`)
- **Purpose**: Enhanced process management
- **Features**: CLI-based task manager with advanced features
- **Usage**: Visual process monitoring and management

#### **Video Downloader** (`pydownload`)
- **Purpose**: Download videos from online platforms
- **Features**: Support for multiple video sources
- **Usage**: CLI interface for video downloading

#### **WiFi Detector** (`pywifi`)
- **Purpose**: Wireless network scanning
- **Features**: WiFi network detection and analysis
- **Usage**: CLI-based wireless network tools

### ⚙️ Python Requirements

Most tools should work with standard Python libraries. Some may require:

```powershell
# Common dependencies
pip install requests
pip install tkinter  # Usually included with Python
pip install psutil   # For system utilities
```

### 🔧 Troubleshooting Python Tools

```powershell
# Check Python installation
python --version

# Verify script locations
Test-Path "python/drawlogo.py"

# Run with absolute path
python "C:\path\to\repo\python\drawlogo.py"
```

## 🛠️ Modules

### **Core Modules (Auto-loaded)**
- **PSReadLine** - Enhanced command line editing
- **Terminal-Icons** - File type icons
- **PSFzf** - Fuzzy finder integration
- **posh-git** - Git status in prompt

### **Optional Modules**
- **PSGitHub** - GitHub integration
- **Z** - Directory jumping
- **PSScriptAnalyzer** - Code quality analysis

## 🎯 Usage Examples

### **Interactive Git Workflow**
```powershell
# Use the interactive Git menu
git-menu

# Clean up merged branches
git-branch-cleanup

# Sync with remote
git-sync
```

### **System Monitoring**
```powershell
# Monitor performance in real-time
Watch-Performance

# Find top resource-consuming processes
Get-TopProcesses -SortBy Memory -Top 5

# Analyze log files
Analyze-LogFile app.log -ErrorsOnly -Statistics
```

### **Network Diagnostics**
```powershell
# Get comprehensive network information
Get-NetworkInfo -Detailed

# Test specific ports
Test-Ports google.com 80,443,22

# Check internet speed
Test-NetworkSpeed
```

### **Development Workflow**
```powershell
# Create and start a new web project
New-Project my-web-app web
Start-DevEnvironment web

# Build C++ project with debugging
Build-And-Run -Clean -Config Debug -Debug

# Analyze code quality
Measure-CodeQuality -Path ./src -Fix
```

## 🔍 Detailed Features

### **Oh My Posh Configuration**
- Dynamic theme detection and fallback
- Multiple theme location support
- Interactive theme switcher with FZF
- Automatic profile persistence

### **PSReadLine Enhancements**
- Predictive IntelliSense
- List view for predictions
- Enhanced color schemes
- Custom key bindings
- History-based suggestions

### **FZF Integration**
- Command history search (Ctrl+R)
- File and directory fuzzy finding
- Git command selection
- Theme browser

### **Error Handling & Robustness**
- Comprehensive try-catch blocks
- Graceful fallbacks for missing components
- Detailed error messages
- Progress indicators

## 🐛 Troubleshooting

### **Common Issues**

1. **Execution Policy Error**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

2. **Module Not Found**
```powershell
Install-Module -Name <ModuleName> -Force -AllowClobber
```

3. **Oh My Posh Not Loading**
```powershell
# Reinstall Oh My Posh
winget uninstall JanDeDobbeleer.OhMyPosh
winget install JanDeDobbeleer.OhMyPosh -s winget
```

4. **FZF Not Working**
```powershell
# Reinstall FZF
winget uninstall fzf
winget install fzf
```

5. **Python Tools Not Working**
```powershell
# Check Python installation
python --version

# Navigate to tools directory
cd python

# Run tool directly
python "task bar.py"
```

### **Debug Mode**
Enable verbose loading:
```powershell
$VerbosePreference = "Continue"
. $PROFILE
```

### **Reset to Default**
```powershell
Remove-Item $PROFILE
# Restart PowerShell
```

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. **Fork the Repository**
2. **Create a Feature Branch**
3. **Make Your Changes**
4. **Test Thoroughly**
5. **Submit a Pull Request**

### **Development Guidelines**
- Follow PowerShell best practices
- Include comprehensive help documentation
- Add error handling for all functions
- Test on both Windows and Linux if possible
- For Python tools, ensure they work with Python 3.6+

### **Adding New Python Tools**
1. Place your Python script in the `/python/` directory
2. Update the PowerShell integration functions
3. Include proper documentation
4. Test the tool independently

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🎊 Enjoy Your Supercharged PowerShell!

With this configuration, you'll have a powerful, beautiful, and highly productive PowerShell environment. The comprehensive set of tools and functions will streamline your workflow and make command-line operations a joy! 🚀

**Happy Coding!** 💻✨

---

