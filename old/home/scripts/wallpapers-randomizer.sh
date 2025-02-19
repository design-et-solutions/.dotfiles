#!/bin/sh

THEME="light-theme"
WALLPAPER_DIR="$HOME/.wallpapers/$THEME"
echo "wallpapers path: $WALLPAPER_DIR"

# Check if the wallpaper directory exists
if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "Error: Wallpaper directory does not exist: $WALLPAPER_DIR"
    exit 1
fi

# Count the number of files in the wallpaper directory
file_count=$(find "$WALLPAPER_DIR"/ -type f | wc -l)
echo "Number of files in wallpaper directory: $file_count"

# Check if hyprpaper is running
if ! pgrep -x "hyprpaper" > /dev/null; then
    echo "Starting hyprpaper..."
    hyprpaper &
    sleep 2  # Give hyprpaper time to start
fi

# Unload any wallpapers that aren't currently in use
echo "Cleaning up unused wallpapers..."
for loaded_wallpaper in $(hyprctl hyprpaper listloaded); do
    if ! hyprctl hyprpaper wallpapers | grep -q "$loaded_wallpaper"; then
        echo "Unloading unused wallpaper: $loaded_wallpaper"
        hyprctl hyprpaper unload "$loaded_wallpaper"
    fi
done

# Set new wallpapers for each display
echo "Setting new wallpapers..."
for display in $(hyprctl monitors | grep "Monitor" | cut -d " " -f 2); do
    echo "Setting wallpaper for display: $display"
    wallpaper="$(find "$WALLPAPER_DIR"/ -type f | shuf -n 1)"
    echo "Selected wallpaper: $wallpaper on $display"
    if [ -f "$wallpaper" ]; then
        echo "Preloading wallpaper..."
        hyprctl hyprpaper preload "$wallpaper"
        echo "Setting wallpaper..."
        hyprctl hyprpaper wallpaper "$display,$wallpaper"
    else
        echo "Error: Selected wallpaper file does not exist: $wallpaper"
    fi
done

echo "Script completed."
