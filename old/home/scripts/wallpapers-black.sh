#!/bin/sh

WALLPAPER_DIR="$HOME/.wallpapers"
WALLPAPER="$WALLPAPER_DIR/black.png"
echo "Wallpaper path: $WALLPAPER"

# Check if the wallpaper file exists
if [ ! -f "$WALLPAPER" ]; then
    echo "Error: Wallpaper file does not exist: $WALLPAPER"
    exit 1
fi

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

# Preload the black wallpaper
echo "Preloading wallpaper..."
hyprctl hyprpaper preload "$WALLPAPER"

# Set the black wallpaper for each display
echo "Setting black wallpaper on all displays..."
for display in $(hyprctl monitors | grep "Monitor" | cut -d " " -f 2); do
    echo "Setting wallpaper for display: $display"
    hyprctl hyprpaper wallpaper "$display,$WALLPAPER"
done

echo "Script completed."
