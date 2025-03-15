#!/usr/bin/env fish

set WALLPAPER_DIR "$HOME/.wallpapers/theme/$THEME"
echo "wallpapers path: $WALLPAPER_DIR"

# Check if the wallpaper directory exists
if test ! -d "$WALLPAPER_DIR"
    echo "Error: Wallpaper directory does not exist: $WALLPAPER_DIR"
    exit 1
end

# Count the number of files in the wallpaper directory
set file_count $(find "$WALLPAPER_DIR"/ -type f | wc -l)
echo "Number of files in wallpaper directory: $file_count"

# Check if hyprpaper is running
if not pgrep -x "hyprpaper" > /dev/null
    echo "Starting hyprpaper..."
    hyprpaper &
    sleep 2  # Give hyprpaper time to start
end

# Unload any wallpapers that aren't currently in use
echo "Cleaning up unused wallpapers..."
for loaded_wallpaper in $(hyprctl hyprpaper listloaded)
    if ! hyprctl hyprpaper wallpapers | grep -q "$loaded_wallpaper"
        echo "Unloading unused wallpaper: $loaded_wallpaper"
        hyprctl hyprpaper unload "$loaded_wallpaper"
    end
end

# Set new wallpapers for each display
echo "Setting new wallpapers..."
for display in $(hyprctl monitors | grep "Monitor" | cut -d " " -f 2)
    echo "Setting wallpaper for display: $display"
    set wallpaper "$(find "$WALLPAPER_DIR"/ -type f | shuf -n 1)"
    echo "Selected wallpaper: $wallpaper on $display"
    if test -f "$wallpaper"
        echo "Preloading wallpaper..."
        hyprctl hyprpaper preload "$wallpaper"
        echo "Setting wallpaper..."
        hyprctl hyprpaper wallpaper "$display,$wallpaper"
    else
        echo "Error: Selected wallpaper file does not exist: $wallpaper"
    end
end

echo "Script completed."
