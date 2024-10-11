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
    if [[ $1 == '--dark' ]]; then
        for file in $HOME/.local/share/rofi/themes/*.rasi; do
            sed -i 's|@import\s*"\./light-theme\.rasi"|@import "./dark-theme.rasi"|'  "$file"
        done
    elif [[ $1 == '--light' ]]; then
        for file in $HOME/.local/share/rofi/themes/*.rasi; do
            sed -i 's|@import\s*"\./dark-theme\.rasi"|@import "./light-theme.rasi"|'  "$file"
        done
    fi
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
