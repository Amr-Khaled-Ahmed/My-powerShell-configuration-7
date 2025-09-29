Here's a detailed section to add to your README.md for the Python tools:

## 🐍 Python Tools Collection

The repository includes several powerful Python utilities located in the `/python/` directory. These tools can be easily integrated into your PowerShell profile for enhanced functionality.

### 📁 Available Python Tools

| Tool | Description | Usage |
|------|-------------|--------|
| **`drawlogo.py`** | Creates ASCII art logos and banners | Perfect for terminal branding |
| **`networkTools.py`** | Advanced network scanning and diagnostics | Network analysis and troubleshooting |
| **`task bar.py`** | Custom taskbar manipulation and monitoring | System task management |
| **`taskmanager.py`** | Enhanced process management interface | Advanced task monitoring |
| **`video_downloader.py`** | Download videos from various platforms | Media content downloading |
| **`wifi detector.py`** | WiFi network scanning and analysis | Wireless network monitoring |

### 🔧 Integration with PowerShell Profile

Add these functions to your `$PROFILE` to seamlessly integrate the Python tools:

```powershell
# Python Tools Integration Functions
function Invoke-PythonTool {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ToolName,
        [string[]]$Arguments = @()
    )
    
    $pythonToolsPath = Join-Path (Split-Path $PROFILE) "python"
    $toolPath = Join-Path $pythonToolsPath "$ToolName.py"
    
    if (Test-Path $toolPath) {
        python $toolPath @Arguments
    } else {
        Write-Error "Python tool '$ToolName' not found at $toolPath"
    }
}

# Individual Tool Functions
function Show-Logo {
    [CmdletBinding()]
    param(
        [string]$Text = "ZeroAccess",
        [string]$Style = "block"
    )
    Invoke-PythonTool -ToolName "drawlogo" -Arguments @("--text", $Text, "--style", $Style)
}

function Get-NetworkScan {
    [CmdletBinding()]
    param(
        [string]$Target = "local",
        [switch]$Detailed
    )
    $args = @("--target", $Target)
    if ($Detailed) { $args += "--detailed" }
    Invoke-PythonTool -ToolName "networkTools" -Arguments $args
}

function Get-TaskManager {
    [CmdletBinding()]
    param(
        [switch]$Monitor,
        [int]$Refresh = 5
    )
    $args = @()
    if ($Monitor) { 
        $args += "--monitor"
        $args += "--refresh"
        $args += $Refresh.ToString()
    }
    Invoke-PythonTool -ToolName "taskmanager" -Arguments $args
}

function Get-TaskBarInfo {
    [CmdletBinding()]
    param()
    Invoke-PythonTool -ToolName "task bar" -Arguments @()
}

function Get-WiFiNetworks {
    [CmdletBinding()]
    param(
        [switch]$Scan,
        [switch]$ListSaved
    )
    $args = @()
    if ($Scan) { $args += "--scan" }
    if ($ListSaved) { $args += "--list-saved" }
    Invoke-PythonTool -ToolName "wifi detector" -Arguments $args
}

function Get-VideoDownload {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Url,
        [string]$Quality = "best",
        [string]$OutputPath = "."
    )
    Invoke-PythonTool -ToolName "video_downloader" -Arguments @(
        "--url", $Url,
        "--quality", $Quality,
        "--output", $OutputPath
    )
}

# Aliases for quick access
Set-Alias -Name pylogo -Value Show-Logo
Set-Alias -Name netscan -Value Get-NetworkScan
Set-Alias -Name pytasks -Value Get-TaskManager
Set-Alias -Name taskbar -Value Get-TaskBarInfo
Set-Alias -Name wifiscan -Value Get-WiFiNetworks
Set-Alias -Name vdownload -Value Get-VideoDownload
```

### 🚀 Usage Examples

```powershell
# Display a custom logo
Show-Logo -Text "MyApp" -Style "modern"

# Network scanning
Get-NetworkScan -Target "192.168.1.0/24" -Detailed

# Monitor processes in real-time
Get-TaskManager -Monitor -Refresh 3

# Scan for WiFi networks
Get-WiFiNetworks -Scan

# Download a video
Get-VideoDownload -Url "https://youtube.com/watch?v=example" -Quality "720p"
```

### 📋 Function Reference

#### **Show-Logo** (`pylogo`)
Creates ASCII art logos for terminal branding.
- `-Text`: Text to display (default: "ZeroAccess")
- `-Style`: Logo style ("block", "modern", "classic")

#### **Get-NetworkScan** (`netscan`)
Advanced network scanning and analysis.
- `-Target`: Network target (IP, range, or "local")
- `-Detailed`: Show detailed information

#### **Get-TaskManager** (`pytasks`)
Enhanced process management with monitoring.
- `-Monitor`: Enable real-time monitoring
- `-Refresh`: Refresh interval in seconds (default: 5)

#### **Get-TaskBarInfo** (`taskbar`)
Windows taskbar information and manipulation.

#### **Get-WiFiNetworks** (`wifiscan`)
Wireless network detection and analysis.
- `-Scan`: Perform active scan
- `-ListSaved`: List saved WiFi networks

#### **Get-VideoDownload** (`vdownload`)
Download videos from various platforms.
- `-Url`: Video URL (required)
- `-Quality`: Video quality ("best", "720p", "480p", etc.)
- `-OutputPath`: Download directory

### ⚙️ Prerequisites

Ensure you have the required Python packages:

```powershell
# Install Python dependencies
pip install requests beautifulsoup4 psutil pywin32
```

### 🎨 Customization

You can extend these functions by modifying the Python scripts or adding parameters to the PowerShell wrappers. Each tool is designed to be modular and extensible.

### 🔍 Troubleshooting

If tools aren't working:
1. Check Python is in your PATH: `python --version`
2. Verify dependencies: `pip list`
3. Ensure script paths are correct in the profile functions

The Python tools integrate seamlessly with your PowerShell environment, providing cross-platform capabilities and extending your command-line toolkit! 🐍⚡
