#!/bin/sh

WALLPAPER_DIR="$HOME/.wallpapers"
echo "wallpapers path: $WALLPAPER_DIR"

# Unload old wallpapers
for wallpaper in $(hyprctl hyprpaper listloaded); do
    hyprctl hyprpaper unload "$wallpaper"
done

# Set new wallpapers for each display
for display in $(hyprctl monitors | grep "Monitor" | cut -d " " -f 2); do
    wallpaper="$(find "$WALLPAPER_DIR" -type f | shuf -n 1)"
    hyprctl hyprpaper preload "$wallpaper"
    hyprctl hyprpaper wallpaper "$display,$wallpaper"
done