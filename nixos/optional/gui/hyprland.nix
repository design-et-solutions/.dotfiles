{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.hyprlock = {
    enable = true;
  };
  security.pam.services.hyprlock = { };
  services.hypridle.enable = true;

  environment.systemPackages = with pkgs; [
    hyprcursor # Hyprland's cursor theme manager
    hyprpaper # Wallpaper utility for Hyprland
  ];
}
