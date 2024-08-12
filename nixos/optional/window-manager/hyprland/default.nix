{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    swww
    thunar
    rofi
    waybar
    dunst
  ];
}
