#!/usr/bin/env fish

echo $THEME
if test "$THEME" = "tokyonight-dark"
    hyprctl keyword general:col.active_border "rgba(a9b1d6ff)" 2&> /dev/null
    hyprctl keyword general:col.inactive_border "rgba(1a1b26ff)" 2&> /dev/null
else if test "$THEME" = "gruvbox-light"
    hyprctl keyword general:col.active_border "rgba(3c3836ff)" 2&> /dev/null
    hyprctl keyword general:col.inactive_border "rgba(fbf1c7ff)" 2&> /dev/null
end
