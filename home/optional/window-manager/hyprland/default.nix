{ ... }:
{
    xdg.configFile."hypr/hyprland.conf".text = builtins.readFile ../../../custom/hypr/hyprland.conf;
}
