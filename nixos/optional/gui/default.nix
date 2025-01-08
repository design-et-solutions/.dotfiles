{ pkgs, mergedSetup, ... }:
{
  imports = [
    ../pkgs/tool/thunar 
    ../pkgs/web/firefox
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

  # Managing the graphical display system on your computer.
  systemd.services.display-manager.serviceConfig = {
    ProtectSystem = "full";
    # ProtectHostname = true;
    ProtectKernelTunables = true;
    ProtectKernelLogs = true;
    ProtectControlGroups = true;
    ProtectClock = true;

    PrivateMounts = true;

    RestrictSUIDSGID = true;
    RestrictRealtime = true;

    SystemCallFilter = [
      "~@raw-io"
      "~@mount"
      "~@swap"
      "~@clock"
      "~@obsolete"
      "~@cpu-emulation"
      "~@debug"
      "~@module"
    ];
    SystemCallArchitectures = "native";

    LockPersonality = true;
  };

  systemd.services."getty@tty7".serviceConfig = {
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
