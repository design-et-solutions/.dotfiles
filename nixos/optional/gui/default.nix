{ pkgs, mergedSetup, ... }:
{
  imports = [
    ../pkgs/thunar 
    ../pkgs/firefox
    ../pkgs/shotman
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
    dbus.enable = true;
  };

  hardware = {
    graphics.enable = true;
  };
}
