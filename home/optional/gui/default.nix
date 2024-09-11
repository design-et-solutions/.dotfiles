{ pkgs, lib, mergedSetup, ... }:
let
  waybarCommand = if mergedSetup.gui.full or false then ''
    exec-once = waybar
  '' else "";
  hyprpaperCommand = if mergedSetup.gui.full or false then ''
    exec-once = hyprpaper
    exec-once = while true; do $HOME/.scripts/wallpapers-randomizer.sh; sleep 900; done
  '' else ''
    exec-once = hyprpaper
    exec-once = $HOME/.scripts/wallpapers-black.sh
  '';
  hyprlandConf = pkgs.substituteAll {
    src = ./hyprland.conf;
    waybar_command = waybarCommand;
    hyprpaper_command = hyprpaperCommand;
    cursor_inactive_timeout = if mergedSetup.gui.full or false then "5" else "0";
    animations_enable = if mergedSetup.gui.full or false then "true" else "false";
  };
in
{
  imports = 
    (lib.optionals mergedSetup.gui.full [
      ../pkgs/waybar 
    ]) ++
    [
      ../pkgs/kitty 
      ../pkgs/rofi 
      ../pkgs/mpv 
    ];

  xdg.configFile = {
    "hypr/hyprland.conf".source = hyprlandConf;
    "hypr/windowrule.conf".source = ./windowrule.conf;
    "hypr/keybindings.conf".source = ./keybindings.conf;
    "hypr/hyprpaper.conf".source = ./hyprpaper.conf;
  };


  home.file = {
    ".scripts/wallpapers-randomizer.sh" = {
      source = builtins.toString ../../scripts/wallpapers-randomizer.sh;
      executable = true;
    };
    ".scripts/wallpapers-black.sh" = {
      source = builtins.toString ../../scripts/wallpapers-black.sh;
      executable = true;
    };
    ".scripts/powermenu.sh" = {
      source = builtins.toString ../../scripts/powermenu.sh;
      executable = true;
    };
    ".wallpapers".source = ../../wallpapers;
  };
}
