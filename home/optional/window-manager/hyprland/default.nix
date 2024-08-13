{ ... }:
{
    xdg.configFile."hypr/hyprland.conf".text = builtins.readFile ../../../../hyprland/hyprland.conf;
}
