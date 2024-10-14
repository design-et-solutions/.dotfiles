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
    animations_enable = if mergedSetup.gui.full or false then "true" else "false";
    custom = mergedSetup.gui.extra.hyprland;
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
    "swappy/config".text = ''
      [Default]
      save_dir=~/Screenshots
      save_filename_format=screenshot-%Y%m%d-%H%M%S.png
      show_panel=false
      line_size=5
      text_size=20
      text_font=sans-serif
    '';
  };


  home.file = {
    ".scripts/wallpapers-randomizer.sh" = {
      source = builtins.toString ../../scripts/wallpapers-randomizer.sh;
      executable = true;
      force = true;
    };
    ".scripts/wallpapers-black.sh" = {
      source = builtins.toString ../../scripts/wallpapers-black.sh;
      executable = true;
      force = true;
    };
    ".wallpapers" = {
      source = ../../wallpapers;
      force = true;
    };
  };

  # screenshot
  home.activation = {
    createDirectories = lib.hm.dag.entryAfter ["writeBoundary"] ''
      mkdir -p ~/Screenshots
    '';
  };
}
