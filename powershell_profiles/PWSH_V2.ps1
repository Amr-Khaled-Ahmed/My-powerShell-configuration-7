$env:POSH_THEME = 'C:\Users\yy171\AppData\Local\Programs\oh-my-posh\themes\atomicBit.omp.json'
$env:POSH_THEME = 'C:\Users\yy171\AppData\Local\Programs\oh-my-posh\themes\smoothie.omp.json'
# ==============================================
# PowerShell Profile Enhancement
# ==============================================

# Clear the screen for a fresh start
# Clear-Host
$profileLoadStart = Get-Date
Write-Host "Loading PowerShell profile..." -ForegroundColor DarkGray


# ----------------------------------------------
# Oh My Posh Initialization
# ----------------------------------------------
try {
    # Check if oh-my-posh is available
    if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
        # Try multiple possible theme locations with more specific order
        $possibleThemePaths = @(
            "${env:POSH_THEMES_PATH}\atomicBit.omp.json",
            "${env:USERPROFILE}\.config\powershell\atomicBit.omp.json",
            "${env:USERPROFILE}\AppData\Local\Programs\oh-my-posh\themes\atomicBit.omp.json",
            "${env:ProgramFiles}\oh-my-posh\themes\atomicBit.omp.json",
            "${env:LocalAppData}\Programs\oh-my-posh\themes\atomicBit.omp.json"
        )

        $ompConfig = $possibleThemePaths | Where-Object {
            $_ -and (Test-Path $_)
        } | Select-Object -First 1

        if ($ompConfig) {
            oh-my-posh init pwsh --config $ompConfig | Invoke-Expression
            Write-Host "Oh My Posh initialized with $ompConfig" -ForegroundColor DarkGray
        } else {
            Write-Warning "Oh My Posh theme not found in any of these locations:`n$($possibleThemePaths -join "`n")"
            # Fallback to default theme
            oh-my-posh init pwsh | Invoke-Expression
            Write-Host "Loaded default Oh My Posh theme" -ForegroundColor DarkGray
        }
    } else {
        Write-Warning "oh-my-posh not found. Please install it with:"
        Write-Host "  winget install JanDeDobbeleer.OhMyPosh -s winget" -ForegroundColor Cyan
        Write-Host "  or" -ForegroundColor DarkGray
        Write-Host "  scoop install https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/oh-my-posh.json" -ForegroundColor Cyan
    }
} catch {
    Write-Error "Failed to initialize oh-my-posh: $_"
    Write-Host "Continuing without Oh My Posh..." -ForegroundColor Yellow
}

# ----------------------------------------------
# PSReadLine Configuration
# ----------------------------------------------
try {
    if (-not (Get-Module PSReadLine -ErrorAction SilentlyContinue)) {
        Import-Module PSReadLine -ErrorAction Stop
    }

    # Enhanced command prediction and history
    Set-PSReadLineOption -PredictionSource HistoryAndPlugin
    Set-PSReadLineOption -PredictionViewStyle ListView
    Set-PSReadLineOption -EditMode Windows
    Set-PSReadLineOption -HistorySearchCursorMovesToEnd
    Set-PSReadLineOption -HistoryNoDuplicates
    Set-PSReadLineOption -MaximumHistoryCount 10000

    # Improved colors with better contrast
    Set-PSReadLineOption -Colors @{
        Command            = [ConsoleColor]::Blue
        Parameter          = [ConsoleColor]::DarkGray
        Operator          = [ConsoleColor]::DarkGray
        Variable          = [ConsoleColor]::Cyan
        String            = [ConsoleColor]::DarkCyan
        Number            = [ConsoleColor]::DarkCyan
        Member            = [ConsoleColor]::DarkGray
        Type              = [ConsoleColor]::DarkYellow
        Default           = [ConsoleColor]::White
        Emphasis          = [ConsoleColor]::Purple
        Comment           = [ConsoleColor]::DarkGreen
        Keyword           = [ConsoleColor]::Blue
        Error             = [ConsoleColor]::Red
    }

    # Enhanced key bindings
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
    Set-PSReadLineKeyHandler -Chord 'Ctrl+f' -Function ForwardWord
    Set-PSReadLineKeyHandler -Chord 'Ctrl+b' -Function BackwardWord

    # Configure PSFzf for history search
    if (Get-Module PSFzf -ListAvailable) {
        Import-Module PSFzf
        Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

        # Set FZF_DEFAULT_OPTS for history search
        $ENV:FZF_DEFAULT_OPTS = @"
--height 40%
--min-height=10
--border=rounded
--layout=reverse
--prompt='❯ '
--pointer='➜'
--margin='0,2'
--info=inline
"@
    }

    Write-Host "PSReadLine configured with enhanced features" -ForegroundColor DarkGray
} catch {
    Write-Warning "Failed to configure PSReadLine: $_"
    Write-Host "Basic command line editing will be available" -ForegroundColor Yellow
}

# ----------------------------------------------
# Optional Module Imports
# ----------------------------------------------
$optionalModules = @(
    @{
        Name = "Terminal-Icons";
        Command = {
            Import-Module Terminal-Icons -ErrorAction SilentlyContinue
            if (Get-Module Terminal-Icons) {
                Write-Host "[+] Loaded module Terminal-Icons" -ForegroundColor DarkGray
            }
        }
    },
    @{
        Name = "PSFzf";
        Command = {
            Import-Module PSFzf -ErrorAction SilentlyContinue
            if (Get-Module PSFzf) {
                Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'
                Write-Host "[+] Loaded module PSFzf with Ctrl+f/Ctrl+r bindings" -ForegroundColor DarkGray
            }
        }
    },
    @{
        Name = "PSGitHub";
        Command = {
            Import-Module PSGitHub -ErrorAction SilentlyContinue
            if (Get-Module PSGitHub) {
                Write-Host "[+] Loaded module PSGitHub" -ForegroundColor DarkGray
            }
        }
    },
    @{
        Name = "posh-git";
        Command = {
            Import-Module posh-git -ErrorAction SilentlyContinue
            if (Get-Module posh-git) {
                Write-Host "[+] Loaded module posh-git" -ForegroundColor DarkGray
            }
        }
    }
)

foreach ($module in $optionalModules) {
    try {
        if (Get-Module -ListAvailable -Name $module.Name) {
            & $module.Command
        } else {
            Write-Host "[ ] Module $($module.Name) not available" -ForegroundColor DarkGray
        }
    } catch {
        Write-Warning "Failed to load module $($module.Name): $_"
    }
}

# ----------------------------------------------
# Git Aliases and Helpers
# ----------------------------------------------
function git-menu {
    [CmdletBinding()]
    param()

    $gitCommands = @(
        # Status & Information
        "git status",
        "git status -v",
        "git status -s",
        "git shortlog -sn --all",
        "git shortlog -sn",
        "git show --name-only",

        # Branching
        "git checkout",
        "git switch",
        "git switch -c",
        "git branch",
        "git branch -a",
        "git branch -vv",
        "git branch -d",
        "git blame",

        # Committing
        "git add",
        "git add .",
        "git add --all",
        "git add -p",
        "git commit -m",
        "git commit -am",
        "git commit --amend",
        "git commit --amend --no-edit",
        "git commit --amend --no-edit --reset-author",

        # History
        "git log --graph --oneline --decorate --all",
        "git log",
        "git log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short",
        "git log --follow",
        "git log --stat",
        "git log --summary",

        # Remote Operations
        "git push",
        "git push --force",
        "git push -u origin HEAD",
        "git pull",
        "git pull --rebase",
        "git fetch --prune",
        "git fetch --all",
        "git remote -v",
        "git remote add",
        "git remote remove",

        # Diffing
        "git diff",
        "git diff --cached",
        "git diff-tree --no-commit-id --name-only -r",
        "git diff --word-diff",
        "git diff --stat",

        # Stashing
        "git stash",
        "git stash apply",
        "git stash pop",
        "git stash list",
        "git stash drop",
        "git stash clear",

        # Rebasing
        "git rebase",
        "git rebase --abort",
        "git rebase --continue",
        "git rebase -i",
        "git rebase --skip",

        # Merging
        "git merge",
        "git merge --no-ff",
        "git merge --abort",
        "git merge --continue",

        # Resetting
        "git reset",
        "git reset --hard",
        "git reset --soft",
        "git reset --mixed",

        # Cleaning
        "git clean",
        "git clean -d",
        "git clean -f",
        "git clean -fd",

        # Tags
        "git tag",
        "git tag -a",
        "git tag -d",
        "git tag --list",

        # Submodules
        "git submodule",
        "git submodule init",
        "git submodule update",
        "git submodule update --recursive",
        "git submodule update --init --recursive",

        # Worktree
        "git worktree",
        "git worktree add",
        "git worktree list",
        "git worktree remove",

        # Bisect
        "git bisect",
        "git bisect start",
        "git bisect good",
        "git bisect bad",
        "git bisect reset",

        # Cherry-pick
        "git cherry-pick",
        "git cherry-pick --abort",
        "git cherry-pick --continue",

        # Reflog
        "git reflog",

        # Config
        "git config --list",
        "git config --global --list"
    )

    if (Get-Command fzf -ErrorAction SilentlyContinue) {
        try {
            $selected = $gitCommands | fzf --height 40% --reverse --prompt='Git Commands > ' --preview-window='right:60%'
            if ($selected) {
                $command = $selected.Trim()

                if (-not $command.StartsWith("git ")) {
                    $command = "git $command"
                }

                # Handle commands that need additional input
                switch -regex ($command) {
                    "git commit -m$|git commit -am$|git tag -a$" {
                        $message = Read-Host "Enter message"
                        $command = "$command `"$message`""
                    }
                    "git checkout$|git switch$|git switch -c$|git branch -d$" {
                        $branch = Read-Host "Enter branch name"
                        $command = "$command $branch"
                    }
                    "git remote add$" {
                        $remote = Read-Host "Enter remote name"
                        $url = Read-Host "Enter remote URL"
                        $command = "$command $remote $url"
                    }
                    "git remote remove$" {
                        $remote = Read-Host "Enter remote name"
                        $command = "$command $remote"
                    }
                    "git add$" {
                        $files = Read-Host "Enter file paths (space separated) or . for all"
                        $command = "$command $files"
                    }
                }

                Write-Host "Executing: $command" -ForegroundColor Cyan
                Invoke-Expression $command
            }
        } catch {
            Write-Error "Error in git-menu: $_"
        }
    } else {
        Write-Host "Git Commands:" -ForegroundColor Yellow
        $gitCommands | ForEach-Object {
            Write-Host $_
        }

        Write-Host "`nFZF not found. Install FZF for interactive selection." -ForegroundColor Red
        Write-Host "Install with: winget install fzf" -ForegroundColor Cyan
    }
}

# ----------------------------------------------
# Oh My Posh Theme Switcher
# ----------------------------------------------
function brain {
    python "D:\Codes and programs\python\note-prog\remmeber.py"
}

function theme {
    [CmdletBinding()]
    param()

    if (-not (Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
        Write-Warning "Oh My Posh is not installed. Please install it first."
        Write-Host "Install with: winget install JanDeDobbeleer.OhMyPosh -s winget" -ForegroundColor Cyan
        return
    }

    if (-not (Get-Command fzf -ErrorAction SilentlyContinue)) {
        Write-Warning "FZF is not installed. Please install it for interactive theme selection."
        Write-Host "Install with: winget install fzf" -ForegroundColor Cyan
        return
    }

    # Determine themes location with more comprehensive search
    $themesPath = $null
    $possibleThemesPaths = @(
        $env:POSH_THEMES_PATH,
        "${env:USERPROFILE}\.config\powershell\themes",
        "${env:USERPROFILE}\AppData\Local\Programs\oh-my-posh\themes",
        "${env:ProgramFiles}\oh-my-posh\themes",
        "${env:LocalAppData}\Programs\oh-my-posh\themes",
        "${env:USERPROFILE}\.poshthemes"
    )

    foreach ($path in $possibleThemesPaths) {
        if ($path -and (Test-Path $path)) {
            $themesPath = $path
            break
        }
    }

    if (-not $themesPath) {
        Write-Error "Could not find Oh My Posh themes directory. Searched in:`n$($possibleThemesPaths -join "`n")"
        return
    }

    Write-Host "Loading themes from $themesPath..." -ForegroundColor Cyan

    try {
        # Get all theme files with full path
        $themeFiles = Get-ChildItem -Path $themesPath -Filter "*.omp.json" -File | Select-Object -ExpandProperty FullName

        if ($themeFiles.Count -eq 0) {
            Write-Error "No themes found in $themesPath"
            return
        }

        $selectedTheme = $themeFiles | fzf --height 70% --reverse --prompt='Select Theme > ' --preview='oh-my-posh --config {} print primary'

        if ($selectedTheme) {
            Write-Host "Applying theme: $(Split-Path $selectedTheme -Leaf)" -ForegroundColor Green

            # Apply the theme
            oh-my-posh init pwsh --config $selectedTheme | Invoke-Expression

            # Offer to update profile for persistence
            $updateProfile = Read-Host "Do you want to save this theme as your default? (y/n)"
            if ($updateProfile -eq "y") {
                $themeVarLine = "`$env:POSH_THEME = '$selectedTheme'"

                # Read the profile content as an array of lines
                $profileLines = Get-Content -Path $PROFILE -Encoding UTF8 -ErrorAction SilentlyContinue

                $found = $false
                for ($i = 0; $i -lt $profileLines.Count; $i++) {
                    # Check if the line starts with the theme variable assignment, ignoring leading whitespace
                    if ($profileLines[$i].TrimStart().StartsWith('`$env:POSH_THEME =')) {
                        $profileLines[$i] = $themeVarLine
                        $found = $true
                        break
                    }
                }

                if (-not $found) {
                    # If not found, add it to the beginning
                    $profileLines = @($themeVarLine) + $profileLines
                }

                # Write the updated content back to the profile with UTF8 encoding
                $profileLines | Set-Content -Path $PROFILE -Encoding UTF8 -Force
                Write-Host "Profile updated. Theme will be applied on new shells." -ForegroundColor Green
            }
        }
    } catch {
        Write-Error "Error in theme switcher: $_"
    }
}

# ----------------------------------------------
# Network Information Function
# ----------------------------------------------
function Get-NetworkInfo {
    [CmdletBinding()]
    param (
        [switch]$IPOnly,
        [switch]$Detailed
    )

    begin {
        $separator = "=" * 50

        # Create color function for output
        function Write-ColorOutput($text, $color) {
            Write-Host $text -ForegroundColor $color
        }

        if (-not $IPOnly) {
            Write-ColorOutput "`n$separator" "Cyan"
            Write-ColorOutput " NETWORK INFORMATION SUMMARY" "Cyan"
            Write-ColorOutput "$separator`n" "Cyan"
        }
    }

    process {
        # IPv4 Addresses
        $ipv4Info = Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue |
                    Where-Object { $_.InterfaceAlias -notmatch 'Loopback' -and $_.IPAddress -ne '127.0.0.1' } |
                    Select-Object InterfaceAlias, IPAddress, PrefixLength

        if ($IPOnly) {
            # Return only IP addresses for piping to other commands
            return $ipv4Info.IPAddress
        }

        # IPv4 Addresses
        Write-ColorOutput "IPv4 ADDRESSES:" "Yellow"
        if ($ipv4Info) {
            $ipv4Info | ForEach-Object {
                Write-Host "$($_.InterfaceAlias): " -NoNewline
                Write-ColorOutput "$($_.IPAddress)/$($_.PrefixLength)" "Green"
            }
        } else {
            Write-Host "No IPv4 addresses found." -ForegroundColor Red
        }

        Write-Host ""

        # IPv6 Addresses (non-temporary, non-link-local)
        Write-ColorOutput "IPv6 ADDRESSES:" "Yellow"
        $ipv6Info = Get-NetIPAddress -AddressFamily IPv6 -ErrorAction SilentlyContinue |
                    Where-Object {
                        $_.InterfaceAlias -notmatch 'Loopback' -and
                        $_.IPAddress -ne '::1' -and
                        -not $_.IPAddress.StartsWith('fe80')
                    } |
                    Select-Object InterfaceAlias, IPAddress, PrefixLength

        if ($ipv6Info) {
            $ipv6Info | ForEach-Object {
                Write-Host "$($_.InterfaceAlias): " -NoNewline
                Write-ColorOutput "$($_.IPAddress)/$($_.PrefixLength)" "Green"
            }
        } else {
            Write-Host "No public IPv6 addresses found." -ForegroundColor Red
        }

        Write-Host ""

        # MAC Addresses
        Write-ColorOutput "MAC ADDRESSES:" "Yellow"
        $adapters = Get-NetAdapter -ErrorAction SilentlyContinue | Where-Object Status -eq 'Up'
        if ($adapters) {
            foreach ($adapter in $adapters) {
                Write-Host "$($adapter.Name): " -NoNewline
                Write-ColorOutput "$($adapter.MacAddress)" "Green"
            }
        } else {
            Write-Host "No active network adapters found." -ForegroundColor Red
        }

        Write-Host ""

        # Default gateway
        Write-ColorOutput "DEFAULT GATEWAY:" "Yellow"
        $defaultGateways = Get-NetRoute -DestinationPrefix '0.0.0.0/0' -ErrorAction SilentlyContinue |
                           Select-Object -ExpandProperty NextHop
        if ($defaultGateways) {
            $defaultGateways | ForEach-Object {
                Write-ColorOutput $_ "Green"
            }
        } else {
            Write-Host "No default gateway found." -ForegroundColor Red
        }

        Write-Host ""

        # DNS Servers
        Write-ColorOutput "DNS SERVERS:" "Yellow"
        $dnsServers = Get-DnsClientServerAddress -ErrorAction SilentlyContinue |
                      Where-Object { $_.ServerAddresses -and $_.AddressFamily -eq 2 } |
                      Select-Object InterfaceAlias, ServerAddresses

        if ($dnsServers) {
            foreach ($dns in $dnsServers) {
                Write-Host "$($dns.InterfaceAlias): " -NoNewline
                Write-ColorOutput "$($dns.ServerAddresses -join ', ')" "Green"
            }
        } else {
            Write-Host "No DNS servers found." -ForegroundColor Red
        }

        Write-Host ""

        # External IP
        Write-ColorOutput "EXTERNAL IP:" "Yellow"
        try {
            $externalIP = Invoke-RestMethod -Uri 'https://api.ipify.org?format=json' -TimeoutSec 3 -ErrorAction Stop
            Write-ColorOutput $externalIP.ip "Green"
        } catch {
            try {
                $externalIP = Invoke-RestMethod -Uri 'https://ifconfig.me/ip' -TimeoutSec 3 -ErrorAction Stop
                Write-ColorOutput $externalIP "Green"
            } catch {
                Write-Host "Could not retrieve external IP. Check your internet connection." -ForegroundColor Red
            }
        }

        # Additional detailed information if requested
        if ($Detailed) {
            Write-Host ""
            Write-ColorOutput "LISTENING PORTS:" "Yellow"
            try {
                $openPorts = Get-NetTCPConnection -State Listen -ErrorAction Stop |
                             Select-Object LocalAddress, LocalPort, @{Name="ProcessName";Expression={(Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue).Name}} |
                             Sort-Object LocalPort

                if ($openPorts) {
                    $openPorts | Format-Table -AutoSize
                } else {
                    Write-Host "No listening ports found." -ForegroundColor Red
                }
            } catch {
                Write-Host "Failed to retrieve listening ports: $_" -ForegroundColor Red
            }

            Write-Host ""
            Write-ColorOutput "NETWORK INTERFACES:" "Yellow"
            try {
                Get-NetAdapter -ErrorAction Stop | Where-Object Status -eq "Up" |
                    Format-Table -AutoSize Name, InterfaceDescription, Status, LinkSpeed
            } catch {
                Write-Host "Failed to retrieve network interfaces: $_" -ForegroundColor Red
            }

            Write-Host ""
            Write-ColorOutput "NETWORK STATISTICS:" "Yellow"
            try {
                $netStats = Get-NetAdapterStatistics -ErrorAction Stop |
                            Where-Object { $_.ReceivedBytes -gt 0 -or $_.SentBytes -gt 0 }
                $netStats | Format-Table -AutoSize Name,
                    @{Name="Received (MB)";Expression={[math]::Round($_.ReceivedBytes/1MB, 2)}},
                    @{Name="Sent (MB)";Expression={[math]::Round($_.SentBytes/1MB, 2)}}
            } catch {
                Write-Host "Failed to retrieve network statistics: $_" -ForegroundColor Red
            }
        }
    }

    end {
        if (-not $IPOnly) {
            Write-Host ""
        }
    }
}

# ----------------------------------------------
# System utilities
# ----------------------------------------------

function l {
    [CmdletBinding()]
    param([string]$Path = ".")
    Get-ChildItem -Path $Path -ErrorAction SilentlyContinue | Format-Table -AutoSize
}

function ll {
    [CmdletBinding()]
    param([string]$Path = ".")
    Get-ChildItem -Path $Path -Force -ErrorAction SilentlyContinue | Format-Table -AutoSize
}

function la {
    [CmdletBinding()]
    param([string]$Path = ".")
    Get-ChildItem -Path $Path -Force -Hidden -ErrorAction SilentlyContinue | Format-Table -AutoSize
}

function lsr {
    [CmdletBinding()]
    param([string]$Path = ".")
    Get-ChildItem -Path $Path -Force -Recurse -ErrorAction SilentlyContinue | Format-Table -AutoSize
}

function lsrh {
    [CmdletBinding()]
    param([string]$Path = $null)

    try {
        if ($Path) {
            # If path is specified, search recursively for hidden files in that path
            Get-ChildItem -Path $Path -Force -Recurse -Hidden -ErrorAction Stop | Format-Table -AutoSize
        } else {
            # Original behavior - search all drives
            Get-PSDrive -PSProvider FileSystem | ForEach-Object {
                $drive = $_.Root
                try {
                    Get-ChildItem -Path $drive -Force -Recurse -Hidden -Depth 2 -ErrorAction Stop
                } catch {
                    Write-Host "Skipping $drive due to access restrictions." -ForegroundColor Yellow
                }
            } | Format-Table -AutoSize
        }
    } catch {
        Write-Host "Error accessing path '$Path': $_" -ForegroundColor Red
    }
}

function which {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$command
    )
    (Get-Command $command -ErrorAction SilentlyContinue).Path
}

# ----------------------------------------------
# System utilities
# ----------------------------------------------

Function netinfo {
    Get-NetAdapter -ErrorAction SilentlyContinue | Select-Object Name, Status, MacAddress, LinkSpeed
}

Function ports {
    Get-NetTCPConnection -ErrorAction SilentlyContinue |
    Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State
}

Function size {
    Get-ChildItem -Recurse -ErrorAction SilentlyContinue |
    Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue |
    Select-Object Count, Sum
}

Function cpuinfo {
    Get-CimInstance Win32_Processor -ErrorAction SilentlyContinue |
    Select-Object Name, NumberOfCores, MaxClockSpeed
}

Function raminfo {
    Get-CimInstance Win32_PhysicalMemory -ErrorAction SilentlyContinue |
    Select-Object Manufacturer, @{Name="CapacityGB";Expression={[math]::Round($_.Capacity/1GB,2)}}, Speed
}

Function sysinfo {
    Get-ComputerInfo -ErrorAction SilentlyContinue |
    Select-Object CsName, WindowsVersion, OsArchitecture, CsManufacturer, CsModel
}

function check-disk {
    Get-PSDrive -PSProvider FileSystem -ErrorAction SilentlyContinue |
    Where-Object { $_.Used -ne $null } |
    Select-Object Name, @{n="Used (GB)";e={[math]::Round($_.Used/1GB,2)}}, @{n="Free (GB)";e={[math]::Round($_.Free/1GB,2)}}
}

function hack-server {
    ssh root@segfault.net
}

function my-hack-server {
    ssh -o "SetEnv SECRET=FksPpsOTJseCOrZBPWmRpQRz" root@lsd.segfault.net
}

# ----------------------------------------------
# Clipboard Management
# ----------------------------------------------
function Set-ClipboardPath {
    $pwd.Path | Set-Clipboard
    Write-Host "Current path copied to clipboard!" -ForegroundColor Green
}

function Get-ClipboardContent {
    Get-Clipboard | Format-List
}

# ----------------------------------------------
# Environment Path Management
# ----------------------------------------------
function Get-PathEnvironment {
    $env:Path -split ';' | Where-Object { $_ } | Sort-Object
}

function Add-PathEnvironment {
    param(
        [Parameter(Mandatory=$true)]
        [string]$NewPath
    )

    if (Test-Path $NewPath) {
        $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
        if ($currentPath -notlike "*$NewPath*") {
            [Environment]::SetEnvironmentVariable(
                "Path",
                "$currentPath;$NewPath",
                "User"
            )
            Write-Host "Added to Path: $NewPath" -ForegroundColor Green
            $env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [Environment]::GetEnvironmentVariable("Path", "User")
        } else {
            Write-Host "Path already exists!" -ForegroundColor Yellow
        }
    } else {
        Write-Host "Path does not exist: $NewPath" -ForegroundColor Red
    }
}

# ----------------------------------------------
# Docker Helper Functions
# ----------------------------------------------
function docker-clean {
    docker system prune -f
    docker volume prune -f
    docker container prune -f
    docker image prune -f
    Write-Host "Docker system cleaned!" -ForegroundColor Green
}

function docker-stop-all {
    docker stop $(docker ps -q)
    Write-Host "All containers stopped!" -ForegroundColor Green
}

function docker-stats {
    docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}"
}

# ----------------------------------------------
# Python Virtual Environment Management
# ----------------------------------------------
function venv {
    param(
        [string]$Name = ".venv",
        [switch]$Install
    )

    if (-not (Test-Path $Name)) {
        python -m venv $Name
        Write-Host "Created virtual environment: $Name" -ForegroundColor Green

        if ($Install) {
            & "./$Name/Scripts/activate"
            if (Test-Path "requirements.txt") {
                pip install -r requirements.txt
                Write-Host "Installed requirements from requirements.txt" -ForegroundColor Green
            }
        }
    } else {
        & "./$Name/Scripts/activate"
    }
}

function venv-save {
    if (Test-Path ".venv") {
        pip freeze > requirements.txt
        Write-Host "Requirements saved to requirements.txt" -ForegroundColor Green
    } else {
        Write-Host "No virtual environment found in current directory" -ForegroundColor Red
    }
}

# ----------------------------------------------
# Enhanced File Search
# ----------------------------------------------
function Find-File {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Pattern,
        [string]$Path = ".",
        [switch]$CaseSensitive,
        [switch]$Recurse
    )

    $params = @{
        Path = $Path
        ErrorAction = "SilentlyContinue"
    }

    if ($Recurse) { $params.Add("Recurse", $true) }
    if ($CaseSensitive) {
        Get-ChildItem @params | Where-Object { $_.Name -cmatch $Pattern }
    } else {
        Get-ChildItem @params | Where-Object { $_.Name -like "*$Pattern*" }
    }
}

function Find-InFile {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Pattern,
        [string]$Path = ".",
        [string]$Extension = "*",
        [switch]$CaseSensitive
    )

    $params = @{
        Path = "$Path\*.$Extension"
        Recurse = $true
        ErrorAction = "SilentlyContinue"
    }

    if ($CaseSensitive) {
        Get-ChildItem @params | Select-String -Pattern $Pattern -CaseSensitive
    } else {
        Get-ChildItem @params | Select-String -Pattern $Pattern
    }
}

# ----------------------------------------------
# System Maintenance
# ----------------------------------------------
function Clear-TempFiles {
    $tempFolders = @(
        "$env:TEMP",
        "$env:SystemRoot\Temp",
        "$env:SystemRoot\Prefetch"
    )

    foreach ($folder in $tempFolders) {
        if (Test-Path $folder) {
            Remove-Item -Path "$folder\*" -Force -Recurse -ErrorAction SilentlyContinue
            Write-Host "Cleaned: $folder" -ForegroundColor Green
        }
    }
}

function Start-SystemMaintenance {
    Write-Host "Starting system maintenance..." -ForegroundColor Cyan

    # Clear DNS Cache
    ipconfig /flushdns
    Write-Host "DNS cache cleared" -ForegroundColor Green

    # Clear Temp Files
    Clear-TempFiles

    # Run Disk Cleanup
    cleanmgr /sagerun:1

    # Check Disk Health
    Get-Volume | Where-Object { $_.DriveLetter } | ForEach-Object {
        Write-Host "Checking drive $($_.DriveLetter):" -ForegroundColor Cyan
        chkdsk $($_.DriveLetter): /f /r
    }

    Write-Host "System maintenance completed!" -ForegroundColor Green
}

# ----------------------------------------------
# Package Manager Wrapper
# ----------------------------------------------
function install {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Package,
        [string]$Manager = "winget"
    )

    switch ($Manager.ToLower()) {
        "winget" {
            winget install $Package
        }
        "scoop" {
            scoop install $Package
        }
        "choco" {
            choco install $Package -y
        }
        "pip" {
            pip install $Package
        }
        "npm" {
            npm install -g $Package
        }
        default {
            Write-Host "Unknown package manager: $Manager" -ForegroundColor Red
        }
    }
}

function update {
    param(
        [string]$Manager = "all"
    )

    switch ($Manager.ToLower()) {
        "all" {
            Write-Host "Updating all package managers..." -ForegroundColor Cyan
            winget upgrade --all
            if (Get-Command scoop -ErrorAction SilentlyContinue) { scoop update * }
            if (Get-Command choco -ErrorAction SilentlyContinue) { choco upgrade all -y }
            if (Get-Command pip -ErrorAction SilentlyContinue) { pip list --outdated --format=freeze | ForEach-Object { pip install -U $_.split('==')[0] } }
        }
        "winget" { winget upgrade --all }
        "scoop" { scoop update * }
        "choco" { choco upgrade all -y }
        "pip" { pip list --outdated --format=freeze | ForEach-Object { pip install -U $_.split('==')[0] } }
        default { Write-Host "Unknown package manager: $Manager" -ForegroundColor Red }
    }
}

# ----------------------------------------------
# Process Management
# ----------------------------------------------
function Get-ProcessDetails {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Name
    )

    Get-Process -Name $Name | Select-Object Id, Name, CPU, WorkingSet, Path, Company, Description |
    Format-Table -AutoSize
}

function Stop-ProcessByPort {
    param (
        [Parameter(Mandatory=$true)]
        [int]$Port
    )

    $process = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue |
               Select-Object -ExpandProperty OwningProcess

    if ($process) {
        $processInfo = Get-Process -Id $process
        Write-Host "Found process: $($processInfo.Name) (ID: $($processInfo.Id))" -ForegroundColor Yellow
        $confirm = Read-Host "Do you want to stop this process? (y/n)"

        if ($confirm -eq 'y') {
            Stop-Process -Id $process -Force
            Write-Host "Process stopped successfully" -ForegroundColor Green
        }
    } else {
        Write-Host "No process found using port $Port" -ForegroundColor Red
    }
}

function Watch-Process {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Name,
        [int]$Interval = 2
    )

    while ($true) {
        Clear-Host
        Get-Process -Name $Name |
        Select-Object Name, Id, CPU, WorkingSet, Handles |
        Format-Table -AutoSize

        Write-Host "Press Ctrl+C to stop monitoring..." -ForegroundColor Yellow
        Start-Sleep -Seconds $Interval
    }
}

# ----------------------------------------------
# Windows Terminal Integration
# ----------------------------------------------
function Set-TerminalBackground {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Color
    )

    $settings = Get-Content "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" | ConvertFrom-Json
    $settings.profiles.defaults.background = $Color
    $settings | ConvertTo-Json -Depth 32 | Set-Content "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    Write-Host "Terminal background color updated. Please restart terminal to apply changes." -ForegroundColor Green
}

function New-TerminalProfile {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Name,
        [string]$Command,
        [string]$Icon = "🚀"
    )

    $settings = Get-Content "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" | ConvertFrom-Json
    $newProfile = @{
        name = $Name
        commandline = $Command
        icon = $Icon
        hidden = $false
    }

    $settings.profiles.list += $newProfile
    $settings | ConvertTo-Json -Depth 32 | Set-Content "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    Write-Host "New terminal profile added. Please restart terminal to apply changes." -ForegroundColor Green
}

# ----------------------------------------------
# Enhanced Git Workflow
# ----------------------------------------------
function git-branch-cleanup {
    # Get current branch
    $currentBranch = git rev-parse --abbrev-ref HEAD

    # Get all merged branches except main, master, and current
    $mergedBranches = git branch --merged |
                      Where-Object { $_ -notmatch "^\*" } |
                      Where-Object { $_.Trim() -notin @("master", "main", $currentBranch) }

    if ($mergedBranches) {
        Write-Host "The following merged branches will be deleted:" -ForegroundColor Yellow
        $mergedBranches | ForEach-Object { Write-Host $_.Trim() }

        $confirm = Read-Host "Continue? (y/n)"
        if ($confirm -eq 'y') {
            $mergedBranches | ForEach-Object {
                git branch -d $_.Trim()
                Write-Host "Deleted branch: $($_.Trim())" -ForegroundColor Green
            }
        }
    } else {
        Write-Host "No merged branches to clean up" -ForegroundColor Green
    }
}

function git-sync {
    $currentBranch = git rev-parse --abbrev-ref HEAD

    Write-Host "Fetching latest changes..." -ForegroundColor Yellow
    git fetch --prune

    Write-Host "Pulling latest changes for $currentBranch..." -ForegroundColor Yellow
    git pull origin $currentBranch

    # Check if main/master exists and pull
    $mainBranch = if (git show-ref --verify --quiet refs/heads/main) { "main" } else { "master" }

    if ($currentBranch -ne $mainBranch) {
        Write-Host "Updating $mainBranch..." -ForegroundColor Yellow
        git checkout $mainBranch
        git pull origin $mainBranch
        git checkout $currentBranch
    }
}

# ----------------------------------------------
# Network Diagnostics
# ----------------------------------------------
function Test-NetworkSpeed {
    Write-Host "Testing download speed..." -ForegroundColor Yellow
    $speedTest = Invoke-RestMethod -Uri 'https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py' -OutFile "$env:TEMP\speedtest.py"
    python "$env:TEMP\speedtest.py" --simple
    Remove-Item "$env:TEMP\speedtest.py"
}

function Test-Ports {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ComputerName,
        [int[]]$Ports = @(80, 443, 3389, 22, 445, 139)
    )

    foreach ($port in $Ports) {
        $result = Test-NetConnection -ComputerName $ComputerName -Port $port -WarningAction SilentlyContinue
        if ($result.TcpTestSucceeded) {
            Write-Host "Port $port is open on $ComputerName" -ForegroundColor Green
        } else {
            Write-Host "Port $port is closed on $ComputerName" -ForegroundColor Red
        }
    }
}

# ----------------------------------------------
# Windows Features Management
# ----------------------------------------------
function Enable-WindowsFeature {
    param (
        [Parameter(Mandatory=$true)]
        [string]$FeatureName
    )

    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Warning "Please run as Administrator"
        return
    }

    try {
        Enable-WindowsOptionalFeature -Online -FeatureName $FeatureName -NoRestart
        Write-Host "Feature $FeatureName enabled successfully" -ForegroundColor Green
    } catch {
        Write-Error "Failed to enable feature: $_"
    }
}

function Get-WindowsFeatures {
    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Warning "Please run as Administrator"
        return
    }

    Get-WindowsOptionalFeature -Online | Where-Object State -eq "Enabled" |
    Select-Object FeatureName, State |
    Format-Table -AutoSize
}

# ----------------------------------------------
# Development Tools
# ----------------------------------------------
function Start-DevEnvironment {
    param (
        [string]$Type = "web"  # web, python, node, dotnet
    )

    switch ($Type.ToLower()) {
        "web" {
            Start-Process "http://localhost:3000"
            code .
            npm start
        }
        "python" {
            if (-not (Test-Path ".venv")) { venv }
            code .
            python app.py
        }
        "node" {
            code .
            npm install
            npm run dev
        }
        "dotnet" {
            code .
            dotnet watch run
        }
        default {
            Write-Host "Unknown environment type. Available: web, python, node, dotnet" -ForegroundColor Red
        }
    }
}

function New-Project {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Name,
        [string]$Type = "web"  # web, python, node, dotnet
    )

    New-Item -ItemType Directory -Path $Name
    Set-Location $Name

    switch ($Type.ToLower()) {
        "web" {
            npx create-react-app .
        }
        "python" {
            New-Item -ItemType File -Path "requirements.txt"
            New-Item -ItemType File -Path "README.md"
            New-Item -ItemType File -Path ".gitignore"
            Add-Content .gitignore ".venv/`n__pycache__/`n*.pyc"
            venv
        }
        "node" {
            npm init -y
            npm install typescript @types/node --save-dev
            npx tsc --init
        }
        "dotnet" {
            dotnet new webapi
        }
        default {
            Write-Host "Unknown project type. Available: web, python, node, dotnet" -ForegroundColor Red
        }
    }
}

# ----------------------------------------------
# Backup Utilities
# ----------------------------------------------
function Backup-Files {
    param (
        [Parameter(Mandatory=$true)]
        [string]$SourcePath,
        [string]$DestinationPath = "$env:USERPROFILE\Backups",
        [switch]$Compress
    )

    if (-not (Test-Path $DestinationPath)) {
        New-Item -ItemType Directory -Path $DestinationPath
    }

    $date = Get-Date -Format "yyyy-MM-dd_HH-mm"
    $backupName = "Backup_$date"
    $backupPath = Join-Path $DestinationPath $backupName

    if ($Compress) {
        Compress-Archive -Path $SourcePath -DestinationPath "$backupPath.zip"
        Write-Host "Backup created at: $backupPath.zip" -ForegroundColor Green
    } else {
        Copy-Item -Path $SourcePath -Destination $backupPath -Recurse
        Write-Host "Backup created at: $backupPath" -ForegroundColor Green
    }
}

function Restore-Backup {
    param (
        [Parameter(Mandatory=$true)]
        [string]$BackupPath,
        [string]$DestinationPath = ".",
        [switch]$Force
    )

    if (-not (Test-Path $BackupPath)) {
        Write-Error "Backup not found: $BackupPath"
        return
    }

    if ($BackupPath.EndsWith(".zip")) {
        Expand-Archive -Path $BackupPath -DestinationPath $DestinationPath -Force:$Force
    } else {
        Copy-Item -Path $BackupPath -Destination $DestinationPath -Recurse -Force:$Force
    }

    Write-Host "Backup restored to: $DestinationPath" -ForegroundColor Green
}

# ----------------------------------------------
# Kubernetes Management
# ----------------------------------------------
function k8s-status {
    param(
        [string]$Namespace = "default",
        [switch]$All
    )

    if (-not (Get-Command kubectl -ErrorAction SilentlyContinue)) {
        Write-Warning "kubectl not found. Please install Kubernetes CLI."
        return
    }

    Write-Host "`nKubernetes Cluster Status" -ForegroundColor Cyan
    Write-Host "------------------------" -ForegroundColor Cyan

    if ($All) {
        $Namespace = "--all-namespaces"
    }

    # Get Nodes
    Write-Host "`nNodes:" -ForegroundColor Yellow
    kubectl get nodes -o wide

    # Get Pods
    Write-Host "`nPods:" -ForegroundColor Yellow
    if ($All) {
        kubectl get pods --all-namespaces
    } else {
        kubectl get pods -n $Namespace
    }

    # Get Services
    Write-Host "`nServices:" -ForegroundColor Yellow
    if ($All) {
        kubectl get services --all-namespaces
    } else {
        kubectl get services -n $Namespace
    }
}

function k8s-cleanup {
    param(
        [string]$Namespace = "default"
    )

    Write-Host "Cleaning up Kubernetes resources in namespace: $Namespace" -ForegroundColor Yellow

    # Delete failed pods
    kubectl get pods -n $Namespace | Where-Object { $_ -match "Error|CrashLoopBackOff" } | ForEach-Object {
        $podName = ($_ -split "\s+")[0]
        kubectl delete pod $podName -n $Namespace
    }

    # Delete evicted pods
    kubectl get pods -n $Namespace | Where-Object { $_ -match "Evicted" } | ForEach-Object {
        $podName = ($_ -split "\s+")[0]
        kubectl delete pod $podName -n $Namespace
    }

    Write-Host "Cleanup completed" -ForegroundColor Green
}

# ----------------------------------------------
# Cloud Tools
# ----------------------------------------------
function cloud-login {
    param(
        [ValidateSet("azure", "aws", "gcp")]
        [string]$Provider = "azure"
    )

    switch ($Provider) {
        "azure" {
            if (Get-Command az -ErrorAction SilentlyContinue) {
                az login
                az account show
            } else {
                Write-Warning "Azure CLI not found. Install with: winget install Microsoft.AzureCLI"
            }
        }
        "aws" {
            if (Get-Command aws -ErrorAction SilentlyContinue) {
                aws configure
                aws sts get-caller-identity
            } else {
                Write-Warning "AWS CLI not found. Install with: winget install Amazon.AWSCLI"
            }
        }
        "gcp" {
            if (Get-Command gcloud -ErrorAction SilentlyContinue) {
                gcloud auth login
                gcloud config list
            } else {
                Write-Warning "Google Cloud SDK not found. Install from: https://cloud.google.com/sdk/docs/install"
            }
        }
    }
}

function az-resources {
    param(
        [string]$ResourceGroup,
        [switch]$Cost
    )

    if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
        Write-Warning "Azure CLI not found"
        return
    }

    if ($ResourceGroup) {
        $message = "Resources in " + $ResourceGroup + ":"
        Write-Host $message -ForegroundColor Cyan
        az resource list --resource-group $ResourceGroup --output table

        if ($Cost) {
            $costMessage = "Cost Analysis for " + $ResourceGroup + ":"
            Write-Host "`n$costMessage" -ForegroundColor Cyan
            az consumption usage list --query "[?contains(resourceGroup, '$ResourceGroup')]"
        }
    } else {
        Write-Host "All Resource Groups:" -ForegroundColor Cyan
        az group list --output table
    }
}

# ----------------------------------------------
# Security Tools
# ----------------------------------------------
function Test-PasswordStrength {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Password
    )

    $score = 0
    $feedback = @()

    # Length check
    if ($Password.Length -lt 8) {
        $feedback += "Password is too short (minimum 8 characters)"
    } else {
        $score += [Math]::Min([Math]::Floor($Password.Length / 2), 5)
    }

    # Complexity checks
    if ($Password -match "[A-Z]") { $score += 2; } else { $feedback += "Missing uppercase letters" }
    if ($Password -match "[a-z]") { $score += 2; } else { $feedback += "Missing lowercase letters" }
    if ($Password -match "[0-9]") { $score += 2; } else { $feedback += "Missing numbers" }
    if ($Password -match "[^A-Za-z0-9]") { $score += 3; } else { $feedback += "Missing special characters" }

    # Output results
    Write-Host "`nPassword Strength Analysis:" -ForegroundColor Cyan
    Write-Host "Score: $score/14" -ForegroundColor $(switch($score) {
        {$_ -lt 5} { "Red" }
        {$_ -lt 10} { "Yellow" }
        default { "Green" }
    })

    if ($feedback) {
        Write-Host "`nSuggestions:" -ForegroundColor Yellow
        $feedback | ForEach-Object { Write-Host "- $_" }
    }
}

function Get-FileHash256 {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path
    )

    if (Test-Path $Path) {
        $hash = Get-FileHash -Path $Path -Algorithm SHA256
        Write-Host "File: $Path" -ForegroundColor Cyan
        Write-Host "SHA256: $($hash.Hash)" -ForegroundColor Green

        # Check VirusTotal (if API key is set)
        if ($env:VIRUSTOTAL_API_KEY) {
            $headers = @{
                "x-apikey" = $env:VIRUSTOTAL_API_KEY
            }
            $uri = "https://www.virustotal.com/api/v3/files/$($hash.Hash)"

            try {
                $response = Invoke-RestMethod -Uri $uri -Headers $headers
                Write-Host "`nVirusTotal Results:" -ForegroundColor Yellow
                Write-Host "Detection ratio: $($response.data.attributes.last_analysis_stats.malicious)/$($response.data.attributes.last_analysis_stats.total)"
            } catch {
                Write-Warning "Could not check VirusTotal"
            }
        }
    } else {
        Write-Error "File not found: $Path"
    }
}

# ----------------------------------------------
# Advanced File Operations
# ----------------------------------------------
function Compare-Directories {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path1,
        [Parameter(Mandatory=$true)]
        [string]$Path2,
        [switch]$ShowAll
    )

    if (-not (Test-Path $Path1) -or -not (Test-Path $Path2)) {
        Write-Error "One or both paths do not exist"
        return
    }

    $dir1 = Get-ChildItem -Path $Path1 -Recurse
    $dir2 = Get-ChildItem -Path $Path2 -Recurse

    $comparison = Compare-Object -ReferenceObject $dir1 -DifferenceObject $dir2 -Property Name, Length

    if ($ShowAll) {
        $comparison | ForEach-Object {
            $status = if ($_.SideIndicator -eq "<=") { "Only in $Path1" } else { "Only in $Path2" }
            [PSCustomObject]@{
                File = $_.Name
                Status = $status
                Size = "$([math]::Round($_.Length/1KB, 2)) KB"
            }
        } | Format-Table -AutoSize
    } else {
        $differences = $comparison | Measure-Object
        Write-Host "Found $($differences.Count) differences" -ForegroundColor Yellow
        Write-Host "Use -ShowAll to see details" -ForegroundColor Gray
    }
}

function Sync-Directories {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Source,
        [Parameter(Mandatory=$true)]
        [string]$Destination,
        [switch]$Mirror,
        [switch]$WhatIf
    )

    if (-not (Test-Path $Source)) {
        Write-Error "Source directory does not exist: $Source"
        return
    }

    $robocopyArgs = @(
        $Source
        $Destination
        "/E"  # Copy subdirectories, including empty ones
        "/Z"  # Copy files in restartable mode
        "/W:1" # Wait time between retries
        "/R:3" # Number of retries
    )

    if ($Mirror) {
        $robocopyArgs += "/MIR"  # Mirror directories
    }

    if ($WhatIf) {
        $robocopyArgs += "/L"  # List only - don't copy
    }

    Write-Host "Syncing directories..." -ForegroundColor Yellow
    robocopy @robocopyArgs

    Write-Host "Sync completed" -ForegroundColor Green
}

# ----------------------------------------------
# Performance Monitoring
# ----------------------------------------------
function Watch-Performance {
    param(
        [int]$Seconds = 5,
        [switch]$Export
    )

    $data = @()

    while ($true) {
        $cpu = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
        $memory = (Get-Counter '\Memory\Available MBytes').CounterSamples.CookedValue
        $disk = (Get-Counter '\PhysicalDisk(_Total)\% Disk Time').CounterSamples.CookedValue

        $timestamp = Get-Date
        $metrics = [PSCustomObject]@{
            Time = $timestamp
            CPU = [math]::Round($cpu, 2)
            MemoryAvailable = [math]::Round($memory, 2)
            DiskUsage = [math]::Round($disk, 2)
        }

        $data += $metrics

        Clear-Host
        Write-Host "Performance Monitor (Ctrl+C to stop)" -ForegroundColor Cyan
        Write-Host "----------------------------------------" -ForegroundColor Cyan
        Write-Host "CPU Usage: $($metrics.CPU)%" -ForegroundColor $(if ($metrics.CPU -gt 80) { "Red" } else { "Green" })
        Write-Host "Memory Available: $($metrics.MemoryAvailable) MB" -ForegroundColor $(if ($metrics.MemoryAvailable -lt 1000) { "Red" } else { "Green" })
        Write-Host "Disk Usage: $($metrics.DiskUsage)%" -ForegroundColor $(if ($metrics.DiskUsage -gt 80) { "Red" } else { "Green" })

        Start-Sleep -Seconds $Seconds
    }

    if ($Export) {
        $exportPath = "PerformanceLog_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
        $data | Export-Csv -Path $exportPath -NoTypeInformation
        Write-Host "Performance data exported to: $exportPath" -ForegroundColor Green
    }
}

function Get-TopProcesses {
    param(
        [ValidateSet("CPU", "Memory", "DiskIO")]
        [string]$SortBy = "CPU",
        [int]$Top = 10
    )

    switch ($SortBy) {
        "CPU" {
            Get-Process | Sort-Object CPU -Descending | Select-Object -First $Top |
            Format-Table -AutoSize Name, ID, @{N='CPU(s)';E={[math]::Round($_.CPU,2)}}, @{N='Memory(MB)';E={[math]::Round($_.WS/1MB,2)}}
        }
        "Memory" {
            Get-Process | Sort-Object WS -Descending | Select-Object -First $Top |
            Format-Table -AutoSize Name, ID, @{N='Memory(MB)';E={[math]::Round($_.WS/1MB,2)}}, @{N='CPU(s)';E={[math]::Round($_.CPU,2)}}
        }
        "DiskIO" {
            Get-Process | Sort-Object ReadOperationCount -Descending | Select-Object -First $Top |
            Format-Table -AutoSize Name, ID, @{N='Read(KB)';E={[math]::Round($_.ReadOperationCount/1KB,2)}}, @{N='Write(KB)';E={[math]::Round($_.WriteOperationCount/1KB,2)}}
        }
    }
}

# ----------------------------------------------
# SSH Management
# ----------------------------------------------
function ssh-config {
    param(
        [string]$Action = "list",
        [string]$Host,
        [string]$HostName,
        [string]$User,
        [string]$IdentityFile
    )

    $sshConfigPath = "$env:USERPROFILE\.ssh\config"

    # Ensure .ssh directory exists
    if (-not (Test-Path "$env:USERPROFILE\.ssh")) {
        New-Item -ItemType Directory -Path "$env:USERPROFILE\.ssh"
    }

    switch ($Action) {
        "list" {
            if (Test-Path $sshConfigPath) {
                Get-Content $sshConfigPath
            } else {
                Write-Host "No SSH config file found" -ForegroundColor Yellow
            }
        }
        "add" {
            if (-not $Host -or -not $HostName) {
                Write-Error "Host and HostName are required"
                return
            }

            $config = @"
Host $Host
    HostName $HostName
"@

            if ($User) {
                $config += "`n    User $User"
            }
            if ($IdentityFile) {
                $config += "`n    IdentityFile $IdentityFile"
            }

            Add-Content -Path $sshConfigPath -Value "`n$config"
            Write-Host "SSH config added for $Host" -ForegroundColor Green
        }
    }
}

function ssh-keygen {
    param(
        [string]$Name = "id_rsa",
        [string]$Comment = "$env:USERNAME@$env:COMPUTERNAME"
    )

    $sshPath = "$env:USERPROFILE\.ssh"

    # Create .ssh directory if it doesn't exist
    if (-not (Test-Path $sshPath)) {
        New-Item -ItemType Directory -Path $sshPath
    }

    # Generate key pair
    ssh-keygen.exe -t rsa -b 4096 -C $Comment -f "$sshPath\$Name"

    # Display public key
    if (Test-Path "$sshPath\$Name.pub") {
        Write-Host "`nPublic Key:" -ForegroundColor Yellow
        Get-Content "$sshPath\$Name.pub"
    }
}

# ----------------------------------------------
# Log Analysis Tools
# ----------------------------------------------
function Analyze-LogFile {
    param(
        [Parameter(Mandatory=$true)]
        [string]$LogPath,
        [string]$Pattern,
        [DateTime]$StartTime,
        [DateTime]$EndTime,
        [switch]$ErrorsOnly,
        [switch]$WarningsOnly,
        [switch]$Statistics
    )

    if (-not (Test-Path $LogPath)) {
        Write-Error "Log file not found: $LogPath"
        return
    }

    $logs = Get-Content $LogPath

    # Filter by time if specified
    if ($StartTime -and $EndTime) {
        $logs = $logs | Where-Object {
            try {
                $logTime = [DateTime]::Parse(($_ -split '\s+')[0])
                $logTime -ge $StartTime -and $logTime -le $EndTime
            } catch {
                $true  # Keep lines that don't parse as dates
            }
        }
    }

    # Filter by pattern if specified
    if ($Pattern) {
        $logs = $logs | Where-Object { $_ -match $Pattern }
    }

    # Filter by log level
    if ($ErrorsOnly) {
        $logs = $logs | Where-Object { $_ -match "ERROR|FAIL|EXCEPTION" }
    }
    if ($WarningsOnly) {
        $logs = $logs | Where-Object { $_ -match "WARN|WARNING" }
    }

    if ($Statistics) {
        $errorCount = ($logs | Where-Object { $_ -match "ERROR|FAIL|EXCEPTION" }).Count
        $warnCount = ($logs | Where-Object { $_ -match "WARN|WARNING" }).Count
        $infoCount = ($logs | Where-Object { $_ -match "INFO" }).Count

        Write-Host "`nLog Statistics:" -ForegroundColor Cyan
        Write-Host "Errors: $errorCount" -ForegroundColor Red
        Write-Host "Warnings: $warnCount" -ForegroundColor Yellow
        Write-Host "Info: $infoCount" -ForegroundColor Green
        Write-Host "Total Lines: $($logs.Count)" -ForegroundColor White
    } else {
        $logs | ForEach-Object {
            switch -Regex ($_) {
                "ERROR|FAIL|EXCEPTION" { Write-Host $_ -ForegroundColor Red }
                "WARN|WARNING" { Write-Host $_ -ForegroundColor Yellow }
                "INFO" { Write-Host $_ -ForegroundColor Green }
                default { Write-Host $_ }
            }
        }
    }
}

# ----------------------------------------------
# Code Quality Tools
# ----------------------------------------------
function Measure-CodeQuality {
    param(
        [string]$Path = ".",
        [string[]]$Extensions = @(".ps1", ".psm1", ".psd1"),
        [switch]$Fix
    )

    # Check for required tools
    if (-not (Get-Command PSScriptAnalyzer -ErrorAction SilentlyContinue)) {
        Write-Warning "PSScriptAnalyzer not found. Install with: Install-Module -Name PSScriptAnalyzer -Force"
        return
    }

    Write-Host "Analyzing code quality..." -ForegroundColor Cyan

    # Get all matching files
    $files = Get-ChildItem -Path $Path -Recurse |
             Where-Object { $Extensions -contains $_.Extension }

    foreach ($file in $files) {
        Write-Host "`nAnalyzing $($file.Name):" -ForegroundColor Yellow

        $results = Invoke-ScriptAnalyzer -Path $file.FullName

        if ($results) {
            $results | ForEach-Object {
                $color = switch ($_.Severity) {
                    "Error" { "Red" }
                    "Warning" { "Yellow" }
                    default { "White" }
                }
                Write-Host "[$($_.Severity)] Line $($_.Line): $($_.Message)" -ForegroundColor $color
            }

            if ($Fix) {
                Write-Host "`nAttempting to fix issues..." -ForegroundColor Cyan
                Invoke-ScriptAnalyzer -Path $file.FullName -Fix
            }
        } else {
            Write-Host "No issues found" -ForegroundColor Green
        }
    }
}

# ----------------------------------------------
# Help Menu System
# ----------------------------------------------
function help-menu {
    $commands = @"
Network Tools
    Get-NetworkInfo        | Display comprehensive network information (-IPOnly, -Detailed)
    netinfo               | Display network adapter information
    ports                | List open ports and connections
    Test-NetworkSpeed    | Test internet speed
    Test-Ports          | Check open ports on remote host

System Information
    size                 | Calculate total size of files in current directory
    cpuinfo              | Display CPU information
    raminfo              | Display RAM information
    sysinfo              | Display system information
    check-disk           | Check disk usage
    Get-TopProcesses     | Show top processes by CPU/Memory/DiskIO

File Management
    l                    | List files in current directory
    la                   | List all files including hidden
    ll                   | List files with details
    lsr                  | List files recursively
    lsrh                 | List hidden files recursively
    Find-File           | Search for files by name pattern
    Find-InFile         | Search for text within files

Development
    Start-DevEnvironment | Start dev environment (web/python/node/dotnet)
    New-Project         | Create new project with template
    Build-And-Run       | Build C++ projects (-Clean/-Config/-Debug)
    Show-BuildHelp      | Display build help
    Measure-CodeQuality | Analyze code quality

Git
    git-menu            | Interactive Git commands
    git-branch-cleanup  | Clean merged branches
    git-sync           | Sync with remote

Docker/K8s
    docker-clean        | Clean Docker system
    docker-stop-all     | Stop all containers
    docker-stats        | Show Docker stats
    k8s-status         | Show K8s status
    k8s-cleanup        | Clean K8s pods

Cloud
    cloud-login        | Login to cloud (azure/aws/gcp)
    az-resources       | List Azure resources

Python
    venv               | Create/activate venv
    venv-save          | Save requirements.txt

Security
    Test-PasswordStrength | Check password strength
    Get-FileHash256      | Get file hash
    ssh-config          | Manage SSH config
    ssh-keygen         | Generate SSH key

Process
    Get-ProcessDetails  | Show process details
    Stop-ProcessByPort  | Stop process by port
    Watch-Process      | Monitor process

System
    Clear-TempFiles    | Clean temp files
    Start-SystemMaintenance | Run maintenance
    Enable-WindowsFeature | Enable Windows feature
    Get-WindowsFeatures | List Windows features

Package
    install            | Install package
    update             | Update packages

Terminal
    theme              | Switch Oh-My-Posh theme
    Set-TerminalBackground | Change terminal color
    New-TerminalProfile | New terminal profile

Utils
    Set-ClipboardPath  | Copy path to clipboard
    Get-ClipboardContent | Show clipboard
    Get-PathEnvironment | List PATH
    Add-PathEnvironment | Add to PATH
    Analyze-LogFile    | Analyze logs
    hack-server        | Connect to segfault
    Get-EnhancedHistory | Show command history
"@

    if (-not (Get-Command fzf -ErrorAction SilentlyContinue)) {
        Write-Host "FZF is not installed. Please install it first:" -ForegroundColor Red
        Write-Host "winget install fzf" -ForegroundColor Yellow
        return
    }

    # Create a temporary file for the help content
    $tempFile = [System.IO.Path]::GetTempFileName()
    $commands | Out-File -FilePath $tempFile -Encoding UTF8

    try {
        # Use FZF to display and select commands with a smaller window
        $selected = Get-Content $tempFile | fzf --ansi `
            --height 40% `
            --min-height 10 `
            --border rounded `
            --header="PowerShell Commands (Ctrl+R)" `
            --layout=reverse `
            --margin="0,2" `
            --prompt="❯ " `
            --pointer="➜" `
            --info=inline

        if ($selected) {
            # Extract the command name (everything before the |)
            $commandName = ($selected -split '\|')[0].Trim()

            # Handle special cases
            switch -Regex ($commandName) {
                "Get-NetworkInfo -.*" {
                    $commandName = "Get-NetworkInfo"
                    $param = ($selected -match "-\w+").Matches[0].Value
                    $commandToRun = "$commandName $param"
                }
                default {
                    $commandToRun = $commandName
                }
            }

            # Show the command that will be executed
            Write-Host "`nExecuting: $commandToRun" -ForegroundColor Cyan

            # Execute the command
            Invoke-Expression $commandToRun
        }
    }
    catch {
        Write-Error "Error in help-menu: $_"
    }
    finally {
        # Cleanup
        Remove-Item $tempFile -ErrorAction SilentlyContinue
    }
}

# Create alias for quick access
Set-Alias -Name h -Value help-menu

# ----------------------------------------------
# Enhanced History
# ----------------------------------------------
function Get-EnhancedHistory {
    Get-History | Format-Table -AutoSize -Wrap @{
        Label="Time"
        Expression={$_.StartExecutionTime.ToString("HH:mm:ss")}
        Width=8
    }, @{
        Label="Duration"
        Expression={($_.EndExecutionTime - $_.StartExecutionTime).ToString("hh\:mm\:ss")}
        Width=10
    }, @{
        Label="Command"
        Expression={if ($_.CommandLine.Length -gt 50) { $_.CommandLine.Substring(0,47) + "..." } else { $_.CommandLine }}
    }
}

# ---------------------------------------------------------------
# build part
# ---------------------------------------------------------------
function Show-BuildHelp {
    Write-ColoredMessage "`nC++ Project Build Helper" "Cyan"
    Write-ColoredMessage "======================" "Cyan"
    Write-ColoredMessage "`nDescription:" "White"
    Write-ColoredMessage "This script helps you build and run C++ CMake projects with ease." "Gray"

    Write-ColoredMessage "`nAvailable Commands:" "White"
    Write-ColoredMessage "1. Build-And-Run              - Build and run the project (interactive mode)" "Yellow"
    Write-ColoredMessage "2. Build-And-Run -Clean       - Clean build directory before building" "Yellow"
    Write-ColoredMessage "3. Build-And-Run -Config X    - Build with specific configuration (Debug/Release)" "Yellow"
    Write-ColoredMessage "4. Build-And-Run -BuildDir X  - Use custom build directory" "Yellow"
    Write-ColoredMessage "5. Show-BuildHelp             - Display this help message" "Yellow"

    Write-ColoredMessage "`nExamples:" "White"
    Write-ColoredMessage ". .\build.ps1                 - Load the script" "Gray"
    Write-ColoredMessage "Build-And-Run                 - Interactive build and run" "Gray"
    Write-ColoredMessage "Build-And-Run -Clean          - Clean and rebuild" "Gray"
    Write-ColoredMessage "Build-And-Run -Config Release - Build Release configuration" "Gray"
    Write-ColoredMessage "Build-And-Run -BuildDir build2 - Use 'build2' directory" "Gray"

    Write-ColoredMessage "`nNotes:" "White"
    Write-ColoredMessage "- Default build directory is 'build'" "Gray"
    Write-ColoredMessage "- Default configuration is 'Release'" "Gray"
    Write-ColoredMessage "- Use -Clean switch to ensure clean build" "Gray"
    Write-ColoredMessage "- Script must be loaded first using '. .\build.ps1'" "Gray"
}

function Write-ColoredMessage {
    param (
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

function Clean-BuildDirectory {
    param (
        [string]$BuildDir = "build"
    )
    if (Test-Path $BuildDir) {
        Write-ColoredMessage "Cleaning build directory..." "Yellow"
        Remove-Item -Path $BuildDir -Recurse -Force
    }
    New-Item -ItemType Directory -Path $BuildDir | Out-Null
    Write-ColoredMessage "Build directory cleaned and recreated." "Green"
}

# ...existing code...
# ...existing code...
function Build-And-Run {
    param (
        [string]$BuildDir = "build",
        [switch]$Clean,
        [string]$Config,
        [switch]$Help,
        [switch]$Debug # <-- Add this line
    )

    if ($Help) {
        Show-BuildHelp
        return
    }

    Write-ColoredMessage "`nC++ Project Builder" "Cyan"
    Write-ColoredMessage "=================" "Cyan"

    # If config not provided, ask user
    if (-not $Config) {
        Write-ColoredMessage "`nBuild Configuration" "Cyan"
        Write-ColoredMessage "1. Debug   - Include debug symbols and no optimization" "White"
        Write-ColoredMessage "2. Release - Optimized build for best performance" "White"
        $choice = Read-Host "`nChoose configuration (1/2)"

        $Config = switch($choice) {
            "1" { "Debug" }
            "2" { "Release" }
            default {
                Write-ColoredMessage "Invalid choice. Using Release configuration." "Yellow"
                "Release"
            }
        }
    }

    Write-ColoredMessage "`nBuild Settings:" "White"
    Write-ColoredMessage "- Configuration: $Config" "Gray"
    Write-ColoredMessage "- Build Directory: $BuildDir" "Gray"
    Write-ColoredMessage "- Clean Build: $Clean" "Gray"
    Write-ColoredMessage "- Debug Mode: $Debug" "Gray" # <-- Show debug mode

    # Clean if requested
    if ($Clean) {
        Clean-BuildDirectory $BuildDir
    }
    elseif (-not (Test-Path $BuildDir)) {
        Write-ColoredMessage "`nCreating build directory..." "Yellow"
        New-Item -ItemType Directory -Path $BuildDir | Out-Null
    }

    # Check for CMakeLists.txt in parent directory
    $cmakeLists = Join-Path (Get-Location) "CMakeLists.txt"
    if (-not (Test-Path $cmakeLists)) {
        Write-ColoredMessage "`nError: CMakeLists.txt not found in $(Get-Location). Please run this command from your project root directory." "Red"
        return
    }

    Push-Location $BuildDir

    try {
        # Configure project
        Write-ColoredMessage "`nConfiguring CMake project..." "Cyan"
        Write-ColoredMessage "Running: cmake .. -DCMAKE_BUILD_TYPE=$Config" "Gray"
        cmake .. -DCMAKE_BUILD_TYPE=$Config
        if ($LASTEXITCODE -ne 0) {
            throw "CMake configuration failed."
        }

        # Build project
        Write-ColoredMessage "`nBuilding project..." "Cyan"
        Write-ColoredMessage "Running: cmake --build . --config $Config" "Gray"
        cmake --build . --config $Config
        if ($LASTEXITCODE -ne 0) {
            throw "Build failed."
        }

        # Find and run the executable
        Write-ColoredMessage "`nLocating executable..." "Cyan"
        $exe = Get-ChildItem -Recurse -Filter "*.exe" | Where-Object { $_.FullName -match $Config }

        if ($exe) {
            Write-ColoredMessage "`nExecutable found: $($exe.Name)" "Green"
            Write-ColoredMessage "`nProgram Output" "Cyan"
            Write-ColoredMessage "=============" "Cyan"
            if ($Debug) {
                # Launch with debugger (Visual Studio if available, else windbg if installed)
                if (Get-Command "devenv.exe" -ErrorAction SilentlyContinue) {
                    Write-ColoredMessage "Launching in Visual Studio debugger..." "Yellow"
                    Start-Process "devenv.exe" -ArgumentList "`"$($exe.FullName)`""
                } elseif (Get-Command "windbg.exe" -ErrorAction SilentlyContinue) {
                    Write-ColoredMessage "Launching in WinDbg..." "Yellow"
                    Start-Process "windbg.exe" -ArgumentList "`"$($exe.FullName)`""
                } else {
                    Write-ColoredMessage "No debugger found. Running normally." "Red"
                    & $exe.FullName
                }
            } else {
                & $exe.FullName
            }
            Write-ColoredMessage "=============" "Cyan"
            Write-ColoredMessage "Program execution completed successfully." "Green"
        } else {
            throw "Executable not found in $BuildDir"
        }
    }
    catch {
        Write-ColoredMessage "`nError: $_" "Red"
        Write-ColoredMessage "Build failed. Use 'Build-And-Run -Help' for usage information." "Yellow"
    }
    finally {
        Pop-Location
    }
}
# ...existing code...
# ...existing code...

# Show help message when script is loaded
Write-ColoredMessage "`nC++ Build Script loaded successfully!" "Green"
Write-ColoredMessage "Use 'Build-And-Run -Help' to see available commands." "Yellow"
Write-ColoredMessage "Example: Build-And-Run -Clean -Config Release`n" "Gray"

# ----------------------------------------------
# Startup Message
# ----------------------------------------------
$loadTime = (Get-Date) - $profileLoadStart
$loadTimeFormatted = if ($loadTime.TotalMilliseconds -lt 1000) {
    "$([math]::Round($loadTime.TotalMilliseconds))ms"
} else {
    "$([math]::Round($loadTime.TotalSeconds,2))s"
}

try {
    python -c @"
import pyfiglet
from colorama import Fore, Style, init
import shutil

init(autoreset=True)

font = 'larry3d'  # 👑 Visually stunning 3D font
width = shutil.get_terminal_size().columns
banner = pyfiglet.figlet_format('ZeroAccess', font=font, width=width)

lines = banner.splitlines()
for line in lines:
    centered = line.center(width)
    print(Fore.LIGHTGREEN_EX + Style.BRIGHT + centered)
"@
}
catch {
    Write-Host ""
    Write-Host "╭━━━━━━━━━━━━━━━━━━━━━━━━━━━━╮" -ForegroundColor Green
    Write-Host "┃        ZeroAccess ⚡        ┃" -ForegroundColor Green
    Write-Host "╰━━━━━━━━━━━━━━━━━━━━━━━━━━━━╯" -ForegroundColor Green
}


Write-Host "Running on $([System.Environment]::OSVersion.VersionString)" -ForegroundColor DarkGray
Write-Host "Profile loaded from $PROFILE" -ForegroundColor DarkGray
Write-Host "Profile loaded in $loadTimeFormatted" -ForegroundColor DarkGray

Write-Host "`nAvailable commands:" -ForegroundColor Cyan

# Help Menu
Write-Host "`nHelp Menu:" -ForegroundColor Yellow
Write-Host "  h, help-menu     " -NoNewline -ForegroundColor Green
Write-Host "- Interactive command help using FZF"

# # Theme and Git
# Write-Host "`nTheme and Git:" -ForegroundColor Yellow
# Write-Host "  theme           " -NoNewline -ForegroundColor Green
# Write-Host "- Switch Oh My Posh themes using FZF"
# Write-Host "  git-menu        " -NoNewline -ForegroundColor Green
# Write-Host "- Interactive Git command selection using FZF"

# # Build Tools
# Write-Host "`nBuild Tools:" -ForegroundColor Yellow
# Write-Host "  Build-And-Run   " -NoNewline -ForegroundColor Green
# Write-Host "- Build and run C++ CMake projects"
# Write-Host "    -Clean        " -NoNewline -ForegroundColor DarkGray
# Write-Host "- Clean build directory before building"
# Write-Host "    -Config X     " -NoNewline -ForegroundColor DarkGray
# Write-Host "- Build with specific configuration (Debug/Release)"
# Write-Host "    -Debug        " -NoNewline -ForegroundColor DarkGray
# Write-Host "- Build and run with debugger"
# Write-Host "  Show-BuildHelp  " -NoNewline -ForegroundColor Green
# Write-Host "- Display build help message"

# # Network Tools
# Write-Host "`nNetwork Tools:" -ForegroundColor Yellow
# Write-Host "  Get-NetworkInfo " -NoNewline -ForegroundColor Green
# Write-Host "- Display comprehensive network information"
# Write-Host "    -IPOnly       " -NoNewline -ForegroundColor DarkGray
# Write-Host "- Return only IP addresses"
# Write-Host "    -Detailed     " -NoNewline -ForegroundColor DarkGray
# Write-Host "- Show detailed network info"
# Write-Host "  netinfo         " -NoNewline -ForegroundColor Green
# Write-Host "- Display network adapter information"
# Write-Host "  ports           " -NoNewline -ForegroundColor Green
# Write-Host "- List open ports"

# # System Information
# Write-Host "`nSystem Information:" -ForegroundColor Yellow
# Write-Host "  size            " -NoNewline -ForegroundColor Green
# Write-Host "- Calculate total size of files in current directory"
# Write-Host "  cpuinfo         " -NoNewline -ForegroundColor Green
# Write-Host "- Display CPU information"
# Write-Host "  raminfo         " -NoNewline -ForegroundColor Green
# Write-Host "- Display RAM information"
# Write-Host "  sysinfo         " -NoNewline -ForegroundColor Green
# Write-Host "- Display system information"
# Write-Host "  check-disk      " -NoNewline -ForegroundColor Green
# Write-Host "- Check disk usage"

# # File Management
# Write-Host "`nFile Management:" -ForegroundColor Yellow
# Write-Host "  l, la, ll, lsr, lsrh " -NoNewline -ForegroundColor Green
# Write-Host "- List files in current directory"
# Write-Host "  Find-File       " -NoNewline -ForegroundColor Green
# Write-Host "- Search for files by name pattern"
# Write-Host "  Find-InFile     " -NoNewline -ForegroundColor Green
# Write-Host "- Search for text within files"
# Write-Host "  Compare-Directories " -NoNewline -ForegroundColor Green
# Write-Host "- Compare contents of two directories"
# Write-Host "  Sync-Directories " -NoNewline -ForegroundColor Green
# Write-Host "- Sync directories using robocopy"

# # Clipboard and Path
# Write-Host "`nClipboard and Path:" -ForegroundColor Yellow
# Write-Host "  Set-ClipboardPath " -NoNewline -ForegroundColor Green
# Write-Host "- Copy current path to clipboard"
# Write-Host "  Get-ClipboardContent " -NoNewline -ForegroundColor Green
# Write-Host "- Display clipboard content"
# Write-Host "  Get-PathEnvironment " -NoNewline -ForegroundColor Green
# Write-Host "- List PATH entries"
# Write-Host "  Add-PathEnvironment " -NoNewline -ForegroundColor Green
# Write-Host "- Add new PATH entry"

# # Docker Management
# Write-Host "`nDocker Management:" -ForegroundColor Yellow
# Write-Host "  docker-clean    " -NoNewline -ForegroundColor Green
# Write-Host "- Clean Docker system"
# Write-Host "  docker-stop-all " -NoNewline -ForegroundColor Green
# Write-Host "- Stop all containers"
# Write-Host "  docker-stats    " -NoNewline -ForegroundColor Green
# Write-Host "- Show Docker statistics"

# # Kubernetes Management
# Write-Host "`nKubernetes Management:" -ForegroundColor Yellow
# Write-Host "  k8s-status      " -NoNewline -ForegroundColor Green
# Write-Host "- Show Kubernetes cluster status"
# Write-Host "  k8s-cleanup     " -NoNewline -ForegroundColor Green
# Write-Host "- Clean up failed and evicted pods"

# # Cloud Tools
# Write-Host "`nCloud Tools:" -ForegroundColor Yellow
# Write-Host "  cloud-login     " -NoNewline -ForegroundColor Green
# Write-Host "- Login to cloud provider (azure/aws/gcp)"
# Write-Host "  az-resources    " -NoNewline -ForegroundColor Green
# Write-Host "- List Azure resources and costs"

# # Security Tools
# Write-Host "`nSecurity Tools:" -ForegroundColor Yellow
# Write-Host "  Test-PasswordStrength " -NoNewline -ForegroundColor Green
# Write-Host "- Analyze password strength"
# Write-Host "  Get-FileHash256       " -NoNewline -ForegroundColor Green
# Write-Host "- Get file hash and check VirusTotal"

# # Performance Monitoring
# Write-Host "`nPerformance Monitoring:" -ForegroundColor Yellow
# Write-Host "  Watch-Performance     " -NoNewline -ForegroundColor Green
# Write-Host "- Monitor system performance in real-time"
# Write-Host "  Get-TopProcesses      " -NoNewline -ForegroundColor Green
# Write-Host "- Show top processes by CPU/Memory/DiskIO"

# # Python Environment
# Write-Host "`nPython Environment:" -ForegroundColor Yellow
# Write-Host "  venv            " -NoNewline -ForegroundColor Green
# Write-Host "- Create/activate Python virtual environment"
# Write-Host "  venv-save       " -NoNewline -ForegroundColor Green
# Write-Host "- Save requirements.txt from current venv"

# # System Maintenance
# Write-Host "`nSystem Maintenance:" -ForegroundColor Yellow
# Write-Host "  Clear-TempFiles " -NoNewline -ForegroundColor Green
# Write-Host "- Clean temporary files"
# Write-Host "  Start-SystemMaintenance " -NoNewline -ForegroundColor Green
# Write-Host "- Run system maintenance tasks"

# # Package Management
# Write-Host "`nPackage Management:" -ForegroundColor Yellow
# Write-Host "  install         " -NoNewline -ForegroundColor Green
# Write-Host "- Install package (winget/scoop/choco/pip/npm)"
# Write-Host "  update          " -NoNewline -ForegroundColor Green
# Write-Host "- Update packages from specified manager"

# # Server Access
# Write-Host "`nServer Access:" -ForegroundColor Yellow
# Write-Host "  hack-server     " -NoNewline -ForegroundColor Green
# Write-Host "- Connect to segfault.net"
# Write-Host "  my-hack-server  " -NoNewline -ForegroundColor Green
# Write-Host "- Connect to lsd.segfault.net"

# # Process Management
# Write-Host "`nProcess Management:" -ForegroundColor Yellow
# Write-Host "  Get-ProcessDetails " -NoNewline -ForegroundColor Green
# Write-Host "- Display detailed process information"
# Write-Host "  Stop-ProcessByPort " -NoNewline -ForegroundColor Green
# Write-Host "- Stop process using specific port"
# Write-Host "  Watch-Process     " -NoNewline -ForegroundColor Green
# Write-Host "- Monitor process in real-time"

# # Windows Terminal
# Write-Host "`nWindows Terminal:" -ForegroundColor Yellow
# Write-Host "  Set-TerminalBackground " -NoNewline -ForegroundColor Green
# Write-Host "- Change terminal background color"
# Write-Host "  New-TerminalProfile   " -NoNewline -ForegroundColor Green
# Write-Host "- Create new terminal profile"

# # Enhanced Git Workflow
# Write-Host "`nEnhanced Git Workflow:" -ForegroundColor Yellow
# Write-Host "  git-branch-cleanup " -NoNewline -ForegroundColor Green
# Write-Host "- Clean up merged branches"
# Write-Host "  git-sync          " -NoNewline -ForegroundColor Green
# Write-Host "- Sync current branch with remote"

# # Network Diagnostics
# Write-Host "`nNetwork Diagnostics:" -ForegroundColor Yellow
# Write-Host "  Test-NetworkSpeed " -NoNewline -ForegroundColor Green
# Write-Host "- Test internet speed"
# Write-Host "  Test-Ports       " -NoNewline -ForegroundColor Green
# Write-Host "- Check open ports on remote host"

# # Windows Features
# Write-Host "`nWindows Features:" -ForegroundColor Yellow
# Write-Host "  Enable-WindowsFeature " -NoNewline -ForegroundColor Green
# Write-Host "- Enable Windows optional feature"
# Write-Host "  Get-WindowsFeatures   " -NoNewline -ForegroundColor Green
# Write-Host "- List enabled Windows features"

# # Development Tools
# Write-Host "`nDevelopment Tools:" -ForegroundColor Yellow
# Write-Host "  Start-DevEnvironment " -NoNewline -ForegroundColor Green
# Write-Host "- Start development environment (web/python/node/dotnet)"
# Write-Host "  New-Project         " -NoNewline -ForegroundColor Green
# Write-Host "- Create new project with template"

# # Backup Utilities
# Write-Host "`nBackup Utilities:" -ForegroundColor Yellow
# Write-Host "  Backup-Files  " -NoNewline -ForegroundColor Green
# Write-Host "- Backup files to destination"
# Write-Host "  Restore-Backup" -NoNewline -ForegroundColor Green
# Write-Host "- Restore files from backup"

# Write-Host "`nSSH Management:" -ForegroundColor Yellow
# Write-Host "  ssh-config        " -NoNewline -ForegroundColor Green
# Write-Host "- Manage SSH config file"
# Write-Host "  ssh-keygen        " -NoNewline -ForegroundColor Green
# Write-Host "- Generate SSH key pair"

# Write-Host "`nLog Analysis:" -ForegroundColor Yellow
# Write-Host "  Analyze-LogFile   " -NoNewline -ForegroundColor Green
# Write-Host "- Analyze log files with filtering and statistics"

# Write-Host "`nCode Quality:" -ForegroundColor Yellow
# Write-Host "  Measure-CodeQuality " -NoNewline -ForegroundColor Green
# Write-Host "- Analyze and fix code quality issues"

# Write-Host "`nHistory:" -ForegroundColor Yellow
# Write-Host "  Get-EnhancedHistory " -NoNewline -ForegroundColor Green
# Write-Host "- Display enhanced command history"

Write-Host "`nTip: Use FZF (Ctrl+R) for command history search" -ForegroundColor DarkGray
