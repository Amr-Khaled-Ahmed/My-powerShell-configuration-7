# 🚀 ZeroAccess PowerShell Configuration

![PowerShell](https://img.shields.io/badge/PowerShell-7+-blue.svg)
![Oh My Posh](https://img.shields.io/badge/Oh%20My%20Posh-Custom%20Themes-green.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

A comprehensive and highly customized PowerShell 7+ configuration profile designed for maximum productivity, beautiful aesthetics, and powerful functionality. Transform your Windows terminal into a professional development environment! ✨

## 📋 Table of Contents

- [🌟 Features](#-features)
- [🚀 Quick Start](#-quick-start)
- [📦 Prerequisites](#-prerequisites)
- [⚙️ Installation](#️-installation)
- [🎨 Customization](#-customization)
- [🔧 Functions & Aliases](#-functions--aliases)
- [🛠️ Modules](#️-modules)
- [🎯 Usage Examples](#-usage-examples)
- [🔍 Detailed Features](#-detailed-features)
- [🐛 Troubleshooting](#-troubleshooting)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)

## 🌟 Features
![PowerShell Configuration Screenshot](images/Screenshot%202025-09-29%20213508.png)
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

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🎊 Enjoy Your Supercharged PowerShell!

With this configuration, you'll have a powerful, beautiful, and highly productive PowerShell environment. The comprehensive set of tools and functions will streamline your workflow and make command-line operations a joy! 🚀

**Happy Coding!** 💻✨

---

*Last updated: $(Get-Date -Format "yyyy-MM-dd")*
