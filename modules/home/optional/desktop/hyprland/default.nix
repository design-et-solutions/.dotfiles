{ config, lib, pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    # extraConfig = ''
    #   # Hyprland configuration
    #   monitor=,preferred,auto,auto
      
    #   # Start some programs
    #   exec-once = waybar & hyprpaper & firefox
      
    #   # Set programs to launch with a keybind
    #   bind = SUPER, Return, exec, alacritty
    #   bind = SUPER, Q, killactive,
    #   bind = SUPER, M, exit,
    #   bind = SUPER, E, exec, dolphin
    #   bind = SUPER, V, togglefloating,
    #   bind = SUPER, R, exec, wofi --show drun
    #   bind = SUPER, P, pseudo,
    # '';
  };

  home.packages = with pkgs; [
    # waybar
    # hyprpaper
    # wofi
  ];
}