{
  pkgs,
  lib,
  mergedSetup,
  ...
}:
let
  notifyCommand = ''
    exec = $HOME/.scripts/mako_reloader.fish
  '';
  barCommand = ''
    exec = $HOME/.scripts/waybar.fish
  '';
  wallpaperCommand = ''
    exec = hyprpaper
    exec = $HOME/.scripts/misc/wallpapers_rand.fish
  '';
  hyprlandCommand = ''
    exec = $HOME/.scripts/hypr_reloader.fish
  '';
  hyprlandConf = pkgs.substituteAll {
    src = ./hyprland.conf;
    notify_command = notifyCommand;
    bar_command = barCommand;
    wallpaper_command = wallpaperCommand;
    hyprland_command = hyprlandCommand;
    animations_enable = "true";
    custom = mergedSetup.gui.params.hyprland.custom;
  };
in
{
  imports = [
    ./waybar
    ./mako
    ./kitty
    ./rofi
  ];

  xdg.configFile = {
    "hypr/hyprland.conf".source = hyprlandConf;
    "hypr/windowrule.conf".source = ./windowrule.conf;
    "hypr/keybindings.conf".source = ./keybindings.conf;
    "hypr/hyprpaper.conf".source = ./hyprpaper.conf;
    "hypr/hyprlock.conf".source = ./hyprlock.conf;
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
    ".scripts/hypr_reloader.fish" = {
      source = builtins.toString ../../scripts/hypr_reloader.fish;
      executable = true;
    };
    ".scripts/misc/loading_notif.fish" = {
      source = builtins.toString ../../scripts/misc/loading_notif.fish;
      executable = true;
    };
    ".scripts/misc/theme_reloader.fish" = {
      source = builtins.toString ../../scripts/misc/theme_reloader.fish;
      executable = true;
    };
    ".scripts/misc/wallpapers_rand.fish" = {
      source = builtins.toString ../../scripts/misc/wallpapers_rand.fish;
      executable = true;
    };
    ".wallpapers" = {
      source = ../../wallpapers;
    };
    ".local/share/icons" = {
      source = ../../cursors;
    };
  };
}
