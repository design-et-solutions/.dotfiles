{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    extraConfig = builtins.readFile ../../../../hyprland/hyprland.conf;
  };

  programs.thunar.enable = true;

  environment.systemPackages = with pkgs; [
    swww
    rofi
    waybar
    dunst
  ];
}
