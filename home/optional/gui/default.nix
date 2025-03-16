{
  pkgs,
  lib,
  mergedSetup,
  ...
}:
let
  notifyCommand = ''
    exec = $HOME/.scripts/gui/mako/reloader.fish
  '';
  barCommand = ''
    exec = $HOME/.scripts/gui/waybar/self.fish
  '';
  wallpaperCommand = ''
    exec = hyprpaper
    exec = $HOME/.scripts/gui/misc/wallpapers_rand.fish
  '';
  hyprlandCommand = ''
    exec = $HOME/.scripts/gui/hyprland/reloader.fish
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
  isWayland = mergedSetup.gui.params.displayServer == "wayland";
in
{
  imports =
    [
      ./mako
      ./kitty
      ./rofi
    ]
    ++ lib.optionals (isWayland) [
      ./waybar
    ];

  xdg.configFile =
    {
      "swappy/config".text = ''
        [Default]
        save_dir=~/Screenshots
        save_filename_format=screenshot-%Y%m%d-%H%M%S.png
        show_panel=false
        line_size=5
        text_size=20
        text_font=sans-serif
      '';
    }
    // (
      if isWayland then
        {
          "hypr/hyprland.conf".source = hyprlandConf;
          "hypr/windowrule.conf".source = ./windowrule.conf;
          "hypr/keybindings.conf".source = ./keybindings.conf;
          "hypr/hyprpaper.conf".source = ./hyprpaper.conf;
          "hypr/hyprlock.conf".source = ./hyprlock.conf;
        }
      else
        { }
    );

  home.file =
    {
      ".scripts/misc/loading_notif.fish" = {
        source = builtins.toString ../../../scripts/misc/loading_notif.fish;
        executable = true;
      };
      ".scripts/gui/misc/theme_reloader.fish" = {
        source = builtins.toString ../../../scripts/gui/misc/theme_reloader.fish;
        executable = true;
      };
      ".scripts/gui/misc/wallpapers_rand.fish" = {
        source = builtins.toString ../../../scripts/gui/misc/wallpapers_rand.fish;
        executable = true;
      };
      ".wallpapers" = {
        source = ../../wallpapers;
      };
      ".local/share/icons" = {
        source = ../../cursors;
      };
    }
    // lib.optionalAttrs isWayland {
      ".scripts/gui/hyprland/reloader.fish" = {
        source = builtins.toString ../../../scripts/gui/hyprland/reloader.fish;
        executable = true;
      };
    };
}
