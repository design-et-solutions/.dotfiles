{ pkgs, ... }:
{
  imports = [
    ../pkgs/thunar 
    ../pkgs/firefox
  ];

  services = { 
    xserver = {
      enable = true;
      displayManager = {
        gdm = {
          enable = true;
          wayland = true;
        };
      };
    };
    ratbagd.enable = true; # DBus daemon to configure input devices
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    hyprpaper
  ];

  hardware = {
    graphics.enable = true;
  };
}
