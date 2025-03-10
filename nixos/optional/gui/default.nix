{
  lib,
  pkgs,
  mergedSetup,
  ...
}:
let
  isWayland = mergedSetup.gui.params.displayServer == "wayland";
in
{
  imports = [
    ./hyprland.nix
    ./wayland.nix
    ./gnome.nix
  ];

  services = {
    displayManager = {
      autoLogin.enable = mergedSetup.gui.params.autoLogin.enable;
      autoLogin.user = mergedSetup.gui.params.autoLogin.user;
    };
    xserver = {
      enable = true;
      displayManager = {
        gdm = {
          enable = true;
          wayland = if isWayland then true else false;
          banner = "go fuck your self";
        };
      };
      desktopManager.gnome.enable = if isWayland then false else true;
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
