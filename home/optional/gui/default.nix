{ pkgs, ... }:
{
  imports = [
    ../pkgs/kitty 
    ../pkgs/rofi 
    ../pkgs/mpv 
    ../pkgs/waybar 
  ];

  xdg.configFile = {
    "hypr/hyprland.conf".source = ./hyprland.conf;
    "hypr/windowrule.conf".source = ./windowrule.conf;
    "hypr/keybindings.conf".source = ./keybindings.conf;
    "hypr/hyprpaper.conf".source = ./hyprpaper.conf;
  };
}
