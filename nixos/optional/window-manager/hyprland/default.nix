{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.configFile."hypr/hyprland.conf".text = builtins.readFile ../../../../hyprland/hyprland.conf;

  programs.thunar.enable = true;

  environment.systemPackages = with pkgs; [
    swww
    rofi
    waybar
    dunst
  ];
}
