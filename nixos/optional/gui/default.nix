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
    ProtectKernelTunables = true;
    ProtectKernelLogs = true;
    ProtectControlGroups = true;
    ProtectClock = true;

    PrivateMounts = true;

    RestrictSUIDSGID = true;
    RestrictRealtime = true;

    SystemCallFilter = [
      "~@mount"
      "~@swap"
      "~@clock"
      "~@obsolete"
      "~@cpu-emulation"
      "~@reboot"
    ];
    SystemCallArchitectures = "native";

    LockPersonality = true;

    CapabilityBoundingSet= [
      "~CAP_SYS_PACCT"
      "~CAP_SYS_MODULE"
      "~CAP_BPF"
      "~CAP_SYS_RAWIO"
      "~CAP_SYS_BOOT"
    ];
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
