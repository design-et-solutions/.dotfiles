#!/usr/bin/env fish

function kitty_reload 
    ln -sf ~/.config/kitty/theme/$THEME.conf ~/.config/kitty/theme.conf
    kill -SIGUSR1 $(pgrep kitty)
end

function mako_reload 
    pkill mako
    mako -c ~/.config/mako/theme/$THEME.conf &
end

function hyprland_reload 
    hyprctl reload
end

function nvim_reload 
    $HOME/.scripts/nvim_reloader.fish
end

function tmux_reload 
    $HOME/.scripts/tmux_reloader.fish
end

echo $argv[1]
if test "$argv[1]" = "--tokyonight-dark"
    set -xU THEME "tokyonight-dark"
    hyprland_reload
else if test "$argv[1]" = "--gruvbox-light"
    set -xU THEME "gruvbox-light"
    hyprland_reload
end
echo "THEME: $THEME"
nvim_reload
tmux_reload
kitty_reload
mako_reload
