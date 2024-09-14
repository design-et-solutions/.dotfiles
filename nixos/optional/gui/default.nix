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

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    hyprpaper
    wlr-randr
  ];

  hardware = {
    graphics.enable = true;
  };

  environment.sessionVariables = {
    WAYLAND_DISPLAY = "wayland-0";
    XDG_SESSION_TYPE = "wayland";
    QT_QPA_PLATFORM = "wayland";
    GDK_BACKEND = "wayland";
  };
}
