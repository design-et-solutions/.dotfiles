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
  ];

  services = {
    displayManager = {
      autoLogin.enable = true;
      autoLogin.user = "me";
      defaultSession = "none+i3";
    };
    xserver = {
      enable = true;
      displayManager = {
        lightdm.enable = true;
      };
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          i3status
          i3lock
          dmenu
          xterm
          feh
        ];
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
    xorg.libX11
    xorg.libxcb
    xorg.libXi
    xorg.libXcomposite
    xorg.xrandr
    xorg.xinput
    xorg.xmodmap
    xorg.xwininfo
    xorg.xhost
    fontconfig.dev
    freetype.dev
    xorg.libX11.dev
    xorg.libxcb.dev
    xorg.libXext.dev
    xorg.libXfixes.dev
    xorg.libXi.dev
    xorg.libXrender.dev
    xorg.libxcb.dev
    xorg.libXtst
    xorg.xinit
    xorg.xrandr
  ];
}
