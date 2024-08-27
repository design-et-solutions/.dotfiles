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


  home.file = {
    ".scripts/wallpapers-randomizer.sh" = {
      source = builtins.toString ../../../scripts/wallpapers-randomizer.sh;
      executable = true;
    };
    ".wallpapers".source = ../../../wallpapers;
  };
}
