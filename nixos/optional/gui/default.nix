{ pkgs, mergedSetup, ... }:
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

  hardware = {
    graphics.enable = true;
  };
}
