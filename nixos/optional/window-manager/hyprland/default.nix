{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.thunar.enable = true; # file manager

  environment.systemPackages = with pkgs; [
    hyprpaper # fast wallpaper utility
    rofi # window switcher, Application launcher and dmenu replacement
    kitty # terminal manager
    dunst # lightweight notification daemon
  ];
}
