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

  systemd.services.display-manager.serviceConfig = {
    NoNewPrivileges = true;

    # ProtectSystem = "full";
    # ProtectHome = true;
    # ProtectHostname = true;
    # ProtectKernelTunables = true;
    # ProtectKernelModules = true;
    # ProtectKernelLogs = true;
    # ProtectControlGroups = true;
    # ProtectClock = true;
    # ProtectProc = "invisible";

    # PrivateTmp = true;
    # PrivateNetwork = true;

    RestrictSUIDSGID = true;
    RestrictRealtime = true;
    RestrictNamespaces = true;
    RestrictAddressFamilies = [ 
      "~AF_INET6"  
      "~AF_INET"
      "~AF_PACKET"
    ];

    # SystemCallFilter = [
    #   "~@swap"
    #   # "~@privileged"
    #   # "~@module"
    #   "~@reboot"
    #   "~@debug"
    #   "~@cpu-emulation"
    # ];
    SystemCallArchitectures = "native";
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
