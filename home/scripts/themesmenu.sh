#!/usr/bin/env bash

# CMDs
host=`hostname`

# Options
light='󰖨 Light'
dark='󰤄 Dark'

# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-p "$host" \
		-theme $HOME/.local/share/rofi/themes/themesmenu.rasi
}

run_rofi() {
	echo -e "$dark\n$light" | rofi_cmd
}


# Execute Command
run_cmd() {
    files_rofi=$HOME/.local/share/rofi/themes/*.rasi
    file_waybar=$HOME/.config/waybar/style.css
    file_kitty=$HOME/.config/kitty/kitty.conf
    file_tmux=$HOME/.config/tmux/tmux.conf
    file_nvim=$HOME/.config/nvim/init.lua
    file_wallpaper=$HOME/.scripts/wallpapers-randomizer.sh
    if [[ $1 == '--dark' ]]; then
        # rofi
        for file in $files_rofi; do
            sed -i 's|@import\s*"\./light-theme\.rasi"|@import "./dark-theme.rasi"|'  "$file"
        done
        # waybar
        sed -i 's|@import\s*"\./light-theme\.css";|@import "./dark-theme.css";|' "$file_waybar"
        # kitty
        sed -i 's|include\s*\./light-theme\.conf|include ./dark-theme.conf|' "$file_kitty"
        # tmux
        sed -i 's|^#\(run-shell.*\/share\/tmux-plugins\/tmux-tokyo-night.*\.tmux\)|\1|' "$file_tmux"
        sed -i 's|^\(run-shell.*\/share\/tmux-plugins\/gruvbox.*\.tmux\)|#&|' "$file_tmux"
        # nvim
        sed -i 's|vim\.cmd("colorscheme gruvbox")|vim.cmd("colorscheme tokyonight-night")|' "$file_nvim"
        # wallpapers
        sed -i 's|THEME="light-theme"|THEME="dark-theme"|' "$file_wallpaper"
        export THEME="DARK"
    elif [[ $1 == '--light' ]]; then
        # rofi
        for file in $files_rofi; do
            sed -i 's|@import\s*"\./dark-theme\.rasi"|@import "./light-theme.rasi"|'  "$file"
        done
        # waybar
        sed -i 's|@import\s*"\./dark-theme\.css";|@import "./light-theme.css";|' "$file_waybar"
        # kitty
        sed -i 's|include\s*\./dark-theme\.conf|include ./light-theme.conf|' "$file_kitty"
        # tmux
        sed -i 's|^#\(run-shell.*\/share\/tmux-plugins\/gruvbox.*\.tmux\)|\1|' "$file_tmux"
        sed -i 's|^\(run-shell.*\/share\/tmux-plugins\/tmux-tokyo-night.*\.tmux\)|#&|' "$file_tmux"
        # nvim
        sed -i 's|vim\.cmd("colorscheme tokyonight-night")|vim.cmd("colorscheme gruvbox")|' "$file_nvim"
        # wallpapers
        sed -i 's|THEME="dark-theme"|THEME="light-theme"|' "$file_wallpaper"
        export THEME="LIGHT"
    fi
    pkill waybar && hyprctl dispatch exec waybar
    kill -SIGUSR1 $(pgrep kitty)
    tmux source-file $file_tmux 
    for server_name in /run/user/1000/nvim.*; do # maybe should be updated later lol
        nvim --server "$server_name" --remote-send ":lua ReloadConfig()<CR>"
    done
    $file_wallpaper
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $dark)
		run_cmd --dark
        ;;
    $light)
		run_cmd --light
        ;;
esac
