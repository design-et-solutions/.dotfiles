#!/bin/bash

# Define the path to your Rofi configuration file
ROFI_CONFIG="$HOME/.config/rofi/config.rasi"

# Function to switch theme
switch_theme() {
    if grep -q "@theme \"dark\"" "$ROFI_CONFIG"; then
        sed -i 's/@theme "dark"/@theme "light"/g' "$ROFI_CONFIG"
        echo "Switched to light theme"
    else
        sed -i 's/@theme "light"/@theme "dark"/g' "$ROFI_CONFIG"
        echo "Switched to dark theme"
    fi
}

# Check if an argument is provided
if [ "$1" = "switch" ]; then
    switch_theme
    exit 0
fi

# Display Rofi menu
selected=$(echo -e "Toggle Theme\nExit" | rofi -dmenu -p "Theme Switcher" -theme ~/.config/rofi/theme-switcher.rasi)

case $selected in
    "Toggle Theme")
        $0 switch
        ;;
    "Exit")
        exit 0
        ;;
esac

