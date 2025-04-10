{
  lib,
  pkgs,
  mergedSetup,
  ...
}:
{
  imports = [
    ./hyprland.nix
    ./wayland.nix
    ./i3.nix
  ];

  services = {
    displayManager.autoLogin = {
      enable = lib.mkDefault false;
      user = lib.mkDefault null;
    };
    xserver = {
      enable = true;
      displayManager = {
        gdm = {
          enable = lib.mkDefault true;
          wayland = mergedSetup.gui.params.displayServer.wayland;
          banner = "go fuck your self";
        };
      };
    };
    ratbagd.enable = true; # DBus daemon to configure input devices
    dbus.enable = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.systemPackages = with pkgs; [
    brightnessctl # Command-line utility to control device brightness
  ];
}
