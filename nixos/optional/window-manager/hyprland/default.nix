{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.thunar.enable = true;

  environment.systemPackages = with pkgs; [
    swww
    rofi
    waybar
    dunst
  ];
}
