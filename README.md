# WindowsOnSteamExeFinder

**WindowsOnSteamExeFinder** is a Linux bash script designed to locate Windows `.exe` files within your Steam Library. It's particularly useful for systems running Steam Play (Proton), such as the **Steam Deck** and other Linux-based distributions like **Linux Mint**. The script allows users to scan their Steam library, filter executables, and directly open their containing folders.

---

## Features:
- Scans the `compatdata` folder for `.exe` files.
- Filters results based on whitelist and blacklist patterns.
- Highlights matching executables.
- Provides a user-friendly selection menu.
- Displays the selected executable's full path.
- Opens the executable's folder in the file explorer.

---

## Introduction

With the rise of Proton on Linux, many Windows games can now run seamlessly. However, navigating the Steam compatibility folder (`compatdata`) to locate specific executables can be tedious. This script automates the process, presenting an easy-to-use interface to find and open `.exe` files in your Steam Library. 

It’s perfect for troubleshooting, tweaking settings, or managing game files on Linux systems.

---

## How to Use

### Prerequisites:
1. **Steam** must be installed and configured for your system.
2. Your games should have been launched at least once to generate the `compatdata` directory.
3. A terminal application is required for running the script.

---

### Step-by-Step Guide:

#### For Steam Deck:

1. **Download the script**:
   - Open the terminal and run:
     ```bash
     curl -o WindowsOnSteamExeFinder.sh https://raw.githubusercontent.com/your-repo/WindowsOnSteamExeFinder/main/WindowsOnSteamExeFinder.sh
     chmod +x WindowsOnSteamExeFinder.sh
     ```

2. **Place whitelist and blacklist files**:
   - Optionally, create `whitelist.txt` and `blacklist.txt` in the same directory as the script to filter specific executables.
   - Example `whitelist.txt`:
     ```
     REDlauncher
     Battle.net
     ```
   - Example `blacklist.txt`:
     ```
     updater
     installer
     ```

3. **Run the script**:
   - Launch the terminal and execute:
     ```bash
     ./WindowsOnSteamExeFinder.sh
     ```

4. **Follow the prompts**:
   - The script will scan for `.exe` files, filter them, and display a list.
   - Select the desired executable by entering its number.

5. **Open the folder**:
   - The script will display the full path of the chosen executable and open its directory in the Steam Deck’s file explorer.

---

#### For Linux Mint:

1. **Download the script**:
   - Open the terminal and run:
     ```bash
     curl -o WindowsOnSteamExeFinder.sh https://raw.githubusercontent.com/your-repo/WindowsOnSteamExeFinder/main/WindowsOnSteamExeFinder.sh
     chmod +x WindowsOnSteamExeFinder.sh
     ```

2. **Prepare whitelist and blacklist (optional)**:
   - Create `whitelist.txt` and `blacklist.txt` in the same folder as the script for advanced filtering.
   - Example `whitelist.txt`:
     ```
     Wow.exe
     Launcher.exe
     ```
   - Example `blacklist.txt`:
     ```
     updater
     uninstall
     ```

3. **Run the script**:
   - Open the terminal and execute:
     ```bash
     ./WindowsOnSteamExeFinder.sh
     ```

4. **Select an executable**:
   - The script will display a numbered list of executables.
   - Choose an executable by typing its number.

5. **Open the directory**:
   - After making your selection, the script will display the path to the `.exe` file and automatically open the folder in your file manager.

---

### Troubleshooting:

1. **`compatdata` folder not found**:
   - Ensure the game has been launched at least once in Steam.

2. **Missing dependencies**:
   - The script relies on `bash`, `xdg-open`, and basic Linux utilities (`find`, `awk`). These are included in most Linux distributions.

3. **No `.exe` files found**:
   - Verify that Steam is installed and the `compatdata` folder exists in:
     - **Steam Deck**: `/home/deck/.local/share/Steam/steamapps/compatdata`
     - **Linux Mint**: `~/.local/share/Steam/steamapps/compatdata` or `~/.steam/steam/steamapps/compatdata`.

---

### License:
This project is licensed under the MIT License. See the LICENSE file for details.

### Contributing:
Pull requests and feature suggestions are welcome! Please ensure changes are well-tested before submitting. 

---

Enjoy exploring your Steam library with **WindowsOnSteamExeFinder**!
