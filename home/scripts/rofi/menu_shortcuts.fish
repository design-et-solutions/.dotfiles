#!/usr/bin/env fish

function hyprland_binds_formating
    hyprctl binds | awk '
        function mod_name(m) {
            return (m == 64) ? "SUPER" : (m == 65) ? "SUPER+SHIFT" : m
        }
        function mouse_rename(m) {
            return (m == "mouse:272") ? "left click" : (m == "mouse:273") ? "right click" : m
        }
        /modmask:/ {mod=$2}
        /key:/ {key=$2}
        /description:/ {
            $1="";
            gsub(/^[[:space:]]+/, "");
            desc=$0;
            printf "%-12s %-12s %-12s\n", mod_name(mod), mouse_rename(key), desc;
        }
    '
end

hyprland_binds_formating | rofi -dmenu \
    -mesg "MOD:                      ACTION:" \
    -theme $HOME/.config/rofi/theme/menu_shortcuts/$THEME.rasi
