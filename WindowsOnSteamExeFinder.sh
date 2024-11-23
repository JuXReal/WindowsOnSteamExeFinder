#!/bin/bash

# Clear the terminal screen at start
clear

# ASCII Art and Intro
print_intro() {
    echo "  __        __              _                                "
    echo "  \\ \\      / /__  ___   __| | ___  _ __ ___   ___  ___  ___ "
    echo "   \\ \\ /\\ / / _ \\/ _ \\ / _\` |/ _ \\| '_ \` _ \\ / _ \\/ _ \\/ __|"
    echo "    \\ V  V /  __/ (_) | (_| | (_) | | | | | |  __/  __/\\__ \\"
    echo "     \\_/\\_/ \\___|\\___/ \\__,_|\\___/|_| |_| |_|\\___|\\___||___/"
    echo ""
    echo " WindowsOnSteamExeFinder"
    echo " Provided by: JuX.Real"
    echo " Please support my Gaming Synth Band: https://NEONYZER.com"
    echo ""
    echo " Use at your own risk!"
    echo ""
}

# Load blacklist and whitelist patterns
load_patterns() {
    SCRIPT_DIR=$(dirname "$0")
    WHITELIST_FILE="$SCRIPT_DIR/whitelist.txt"
    BLACKLIST_FILE="$SCRIPT_DIR/blacklist.txt"

    echo "Loading configuration files..."

    if [ -f "$WHITELIST_FILE" ]; then
        mapfile -t WHITELIST < "$WHITELIST_FILE"
        echo -e "Whitelist: \e[32mLoaded\e[0m"
    else
        WHITELIST=()
        echo -e "Whitelist: \e[31mMissing\e[0m"
    fi

    if [ -f "$BLACKLIST_FILE" ]; then
        mapfile -t BLACKLIST < "$BLACKLIST_FILE"
        echo -e "Blacklist: \e[32mLoaded\e[0m"
    else
        BLACKLIST=()
        echo -e "Blacklist: \e[31mMissing\e[0m"
    fi

    echo ""
}

# Detect system type (Steam Deck or other Linux)
detect_system() {
    if grep -q "Steam Deck" /etc/os-release 2>/dev/null || [ -d "/home/deck" ]; then
        echo "Steam Deck detected."
        return 0
    else
        echo "Running on a non-Steam Deck system."
        return 1
    fi
}

# Set compatdata path based on the system
set_compatdata_path() {
    if detect_system; then
        # Steam Deck default path
        COMPATDATA_PATH="/home/deck/.local/share/Steam/steamapps/compatdata"
    else
        # General Linux (e.g., Linux Mint)
        COMPATDATA_PATH="$HOME/.steam/steam/steamapps/compatdata"
        if [ ! -d "$COMPATDATA_PATH" ]; then
            # Alternative for some Linux installations
            COMPATDATA_PATH="$HOME/.local/share/Steam/steamapps/compatdata"
        fi
    fi

    # Verify if the path exists
    if [ ! -d "$COMPATDATA_PATH" ]; then
        echo "Could not locate the compatdata directory: $COMPATDATA_PATH"
        exit 1
    fi
}

# Display progress bar
progress_bar() {
    local current=$1
    local total=$2
    local label=$3
    local progress=$((current * 100 / total))
    echo -ne "$label: ["
    printf '=%.0s' $(seq 1 $((progress / 2)))
    printf ' %.0s' $(seq $((progress / 2 + 1)) 50)
    echo -ne "] $progress%\r"
}

# Apply filtering and highlighting
process_executables() {
    local total=${#EXECUTABLES[@]}
    local filtered=()
    local paths=()
    local i=0

    for exe_entry in "${EXECUTABLES[@]}"; do
        ((i++))
        progress_bar "$i" "$total" "Apply Filter"
        APP_ID=$(echo "$exe_entry" | awk -F ": " '{print $1}')
        EXE_PATH=$(echo "$exe_entry" | awk -F ": " '{print $2}')

        # Filter using blacklist
        for pattern in "${BLACKLIST[@]}"; do
            if echo "$EXE_PATH" | grep -iq "$pattern"; then
                continue 2  # Skip this entry
            fi
        done

        # Add to filtered list
        filtered+=("$APP_ID: $(basename "$EXE_PATH")")
        paths+=("$EXE_PATH")
    done

    echo ""
    echo "Matched executables:"
    for i in "${!filtered[@]}"; do
        echo "$((i + 1))) ${filtered[$i]}"
    done

    echo ""
    echo "Enter the number of the executable you want to open:"
    read -r CHOICE
    if [[ "$CHOICE" =~ ^[0-9]+$ ]] && [ "$CHOICE" -ge 1 ] && [ "$CHOICE" -le "${#paths[@]}" ]; then
        CHOSEN_PATH="${paths[$((CHOICE - 1))]}"
        echo "Selected executable path: $CHOSEN_PATH"
        xdg-open "$(dirname "$CHOSEN_PATH")" &>/dev/null &
    else
        echo "Invalid choice. Exiting."
    fi
}

# Main function
main() {
    clear
    print_intro
    load_patterns
    set_compatdata_path

    # Scan directories and count
    echo "Scanning $COMPATDATA_PATH for executable files (*.exe)..."
    TMP_FILE=$(mktemp)
    TOTAL_FOLDERS=$(find "$COMPATDATA_PATH" -mindepth 1 -maxdepth 1 -type d | wc -l)
    CURRENT_FOLDER=0

    for folder in "$COMPATDATA_PATH"/*; do
        if [ -d "$folder" ]; then
            CURRENT_FOLDER=$((CURRENT_FOLDER + 1))
            progress_bar "$CURRENT_FOLDER" "$TOTAL_FOLDERS" "Scanning"
            find "$folder" -type f -name "*.exe" >> "$TMP_FILE"
        fi
    done
    echo ""

    if [ ! -s "$TMP_FILE" ]; then
        echo "No executable files (*.exe) found!"
        rm "$TMP_FILE"
        exit 1
    fi

    mapfile -t EXECUTABLES < <(
        while IFS= read -r line; do
            APP_ID=$(echo "$line" | awk -F "/compatdata/" '{print $2}' | awk -F "/" '{print $1}')
            EXE_PATH=$(realpath "$line")
            echo "$APP_ID: $EXE_PATH"
        done < "$TMP_FILE"
    )
    rm "$TMP_FILE"

    process_executables
}

# Run the main function
main
