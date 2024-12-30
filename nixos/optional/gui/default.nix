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
    ProtectSystem = "strict";
    PrivateTmp = true;
    NoNewPrivileges = true;
    PrivateDevices = true;
    DevicePolicy= "closed";
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectKernelLogs = true;
  };

  systemd.services."getty@tty7".serviceConfig = {
    PrivateTmp = true;
    PrivateDevices = true;
    DevicePolicy= "closed";
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectKernelLogs = true;
    NoNewPrivileges = true;
    MemoryDenyWriteExecute = true;
    LockPersonality = true; 
    ProtectHostname = true;
    RestrictRealtime = true;
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
