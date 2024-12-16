{ pkgs, mergedSetup, ... }:
{
  imports = [
    ../pkgs/thunar 
    ../pkgs/firefox
  ];

  environment.variables = {
    THEME = "LIGHT";
  };


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

  environment.systemPackages = with pkgs; [
    swaylock-effects
    brightnessctl

    # screenshot
    swappy
    grim
    slurp
    wl-clipboard
  ]; 
}
