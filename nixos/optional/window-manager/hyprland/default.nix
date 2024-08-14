{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.thunar.enable = true;

  environment.systemPackages = with pkgs; [
    hyprpaper # fast wallpaper utility
    rofi # window switcher, Application launcher and dmenu replacement
    dunst # lightweight notification daemon
    kitty # terminal manager
  ];
}
