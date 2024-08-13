{ ... }:
{
    xdg.configFile."hypr/hyprland.conf".text = builtins.readFile ../../../custom/hypr/hyprland.conf;
    xdg.configFile."nvim/init.lua".text = builtins.readFile ../../../custom/nvim/init.lua;
}
