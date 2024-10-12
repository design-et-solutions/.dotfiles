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
    files_rofi = $HOME/.local/share/rofi/themes/*.rasi
    file_waybar = $HOME/.config/waybar/style.css
    if [[ $1 == '--dark' ]]; then
        for file in $files_rofi; do
            sed -i 's|@import\s*"\./light-theme\.rasi"|@import "./dark-theme.rasi"|'  "$file"
        done
        sed -i 's|@import\s*"\./light-theme\.css";|@import "./dark-theme.css";|' "$file_waybar"
    elif [[ $1 == '--light' ]]; then
        for file in $files_rofi; do
            sed -i 's|@import\s*"\./dark-theme\.rasi"|@import "./light-theme.rasi"|'  "$file"
        done
        sed -i 's|@import\s*"\./dark-theme\.css";|@import "./light-theme.css";|' "$file_waybar"
    fi
    hyprctl reload
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
