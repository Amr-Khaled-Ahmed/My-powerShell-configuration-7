
-----

# My PowerShell Configuration 7

This repository contains a highly customized and enhanced PowerShell profile script designed to elevate your command-line experience on Windows. It integrates popular third-party tools, offers a rich set of custom functions for common tasks, and provides system and development utility aliases to boost your productivity.

-----

## ✨ Features

  * **Customizable Prompt with Oh My Posh:**
      * Dynamic loading of Oh My Posh themes.
      * Includes a built-in `theme` function to interactively switch and preview themes using `fzf`, with an option to save your preferred theme for persistence.
  * **Enhanced Command Line with PSReadLine:**
      * Intelligent **command prediction** from history and plugins.
      * Customizable **color scheme** for better readability of commands, parameters, strings, and errors.
      * Improved **key bindings** for efficient navigation and history search (e.g., `Tab` for `MenuComplete`, `Up/Down Arrow` for history search).
      * Integration with **PSFzf** for powerful, interactive history searching (`Ctrl+f`, `Ctrl+r`).
  * **Intelligent Git Workflow:**
      * **`git-menu` function:** An interactive `fzf`-powered menu providing quick access to a wide array of Git commands, including common operations for status, branching, committing, history, remotes, diffing, stashing, rebasing, merging, and more.
      * Automatic loading of `posh-git` for Git status integration in your prompt (if available).
  * **Comprehensive System Information & Utilities:**
      * **Network Diagnostics (`Get-NetworkInfo`):** Quickly view IPv4/IPv6 addresses, MAC addresses, default gateway, DNS servers, and external IP. Includes options for detailed output or IP-only.
      * **System Information (`cpuinfo`, `raminfo`, `sysinfo`, `check-disk`):** Get quick snapshots of your CPU, RAM, system, and disk usage.
      * **Process & Port Management (`ports`):** List all listening TCP connections and their associated processes.
  * **Convenient File System Navigation & Search:**
      * **Enhanced `ls` aliases (`l`, `ll`, `la`, `lsr`, `lsrh`):** Provides shortcuts for listing directory contents with various options (e.g., `l` for `ls -l`, `ll` for `ls -la`, `lsrh` for recursive hidden file search).
      * **`Find-File` & `Find-InFile`:** Powerful functions to search for files by pattern or search for content within files.
  * **Developer & DevOps Helpers:**
      * **Docker Utilities (`docker-clean`, `docker-stop-all`, `docker-stats`):** Simplify common Docker operations like pruning, stopping all containers, and viewing live stats.
      * **Python Virtual Environment Management (`venv`, `venv-save`):** Easily create, activate, and manage Python virtual environments, including saving/installing `requirements.txt`.
      * **Package Manager Wrapper (`install`, `update`):** A unified interface to install and update packages using `winget`, `scoop`, `choco`, `pip`, and `npm`.
  * **Clipboard Management (`Set-ClipboardPath`, `Get-ClipboardContent`):** Quickly copy the current directory path or retrieve clipboard content.
  * **Environment Path Management (`Get-PathEnvironment`, `Add-PathEnvironment`):** Streamline managing your system's PATH environment variable.
  * **Routine System Maintenance (`Clear-TempFiles`, `Start-SystemMaintenance`):** Automate tasks like clearing DNS cache, temporary files, and running disk checks.

-----

## 🚀 Getting Started

### Prerequisites

To get the most out of this profile, ensure you have the following installed:

  * **PowerShell 7+:** While some features may work on older versions, PowerShell 7 (or later) is highly recommended for full compatibility and performance.
      * [Install PowerShell](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows)
  * **Oh My Posh:** Essential for the customizable prompt.
    ```powershell
    winget install JanDeDobbeleer.OhMyPosh -s winget
    # or if you use Scoop:
    scoop install https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/oh-my-posh.json
    ```
  * **Nerd Font:** Crucial for displaying the icons and glyphs used by Oh My Posh themes correctly. After installing, set it as your font in your terminal application (e.g., Windows Terminal).
      * [Download Nerd Fonts](https://www.google.com/search?q=https://www.nerdfonts.com/downloads)
  * **fzf (Fuzzy Finder):** Highly recommended for interactive menus like `git-menu` and `theme`.
    ```powershell
    winget install fzf
    ```

### Optional Modules (Recommended)

The profile will attempt to load these if they are installed, providing additional functionality:

  * **Terminal-Icons:** Displays file and folder icons.
    ```powershell
    Install-Module -Name Terminal-Icons -Scope CurrentUser
    ```
  * **PSFzf:** Integrates `fzf` with PSReadLine for powerful history search.
    ```powershell
    Install-Module -Name PSFzf -Scope CurrentUser
    ```
  * **posh-git:** Provides Git status information for your prompt.
    ```powershell
    Install-Module -Name posh-git -Scope CurrentUser
    ```

### Installation Steps

1.  **Locate your PowerShell Profile:**
    Open PowerShell and type `$PROFILE` and press Enter. This will output the full path to your current PowerShell profile file (e.g., `C:\Users\YourUser\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`).
      * If the file doesn't exist, you can create it:
        ```powershell
        if (-not (Test-Path $PROFILE)) {
            New-Item -Path $PROFILE -ItemType File -Force
        }
        ```
2.  **Edit your Profile File:**
    Open the profile file in your preferred text editor (e.g., `notepad $PROFILE`, `code $PROFILE`).
3.  **Copy the Script Content:**
    Copy the entire content of the `Microsoft.PowerShell_profile.ps1` script from this repository and paste it into your profile file.
4.  **Save and Restart:**
    Save the changes to your profile file and then close and reopen your PowerShell terminal. Your new configuration should now be active\!

-----

## 💡 Usage Examples

All functions and aliases defined in the profile will be immediately available in your PowerShell session.

### Oh My Posh Themes

```powershell
theme                  # Interactively select and apply a new Oh My Posh theme
```

### Git Utilities

```powershell
git-menu               # Open an interactive menu for common Git commands
gs                     # Alias for git status
gc "My commit message" # Alias for git commit -m "My commit message"
gac "Add all and commit" # Alias for git commit -am "Add all and commit"
```

### Network & System Info

```powershell
Get-NetworkInfo        # Display a summary of your network configuration
Get-NetworkInfo -Detailed # Show more comprehensive network details
netinfo                # Quick overview of network adapters
ports                  # List listening TCP ports
cpuinfo                # Get CPU information
check-disk             # View disk usage for all drives
```

### File System

```powershell
l                      # List items in current directory
ll                     # List all items including hidden
lsrh C:\              # Recursively find hidden files starting from C:\ (can take time)
Find-File "MyFile.txt" # Search for files named "MyFile.txt" in current dir
Find-InFile "pattern" -Extension "log" # Search for "pattern" in .log files
```

### Python Virtual Environments

```powershell
venv myenv             # Create and activate a new virtual environment named 'myenv'
venv .venv -Install    # Create/activate default .venv and install requirements if file exists
venv-save              # Save currently installed packages to requirements.txt
```

### Docker Helpers

```powershell
docker-clean           # Prune all Docker system resources
docker-stop-all        # Stop all running Docker containers
docker-stats           # View live Docker container resource usage
```

### Package Management

```powershell
install -Package "vscode" -Manager "winget" # Install VS Code using winget
install -Package "nodejs" -Manager "scoop" # Install Node.js using scoop
update -Manager "all"                  # Update all known package managers
```

-----

## 🤝 Contributing

Contributions are welcome\! If you have suggestions for new functions, improvements to existing ones, or bug fixes, please feel free to:

1.  **Fork** the repository.
2.  **Create** a new branch (`git checkout -b feature/your-feature`).
3.  **Commit** your changes (`git commit -m 'Add new feature'`).
4.  **Push** to the branch (`git push origin feature/your-feature`).
5.  **Open a Pull Request**.

-----

## 📄 License

This project is open-source and available under the [MIT License](https://www.google.com/search?q=LICENSE).

-----

## ⭐ Show Your Support

If you find this PowerShell configuration useful, consider giving the repository a star\!

-----
