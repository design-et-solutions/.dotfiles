#!/usr/bin/env fish

if test ! -e $HOME/.config/kitty/theme.conf
    ln -sf ~/.config/kitty/theme/$THEME.conf ~/.config/kitty/theme.conf
end
kitty
