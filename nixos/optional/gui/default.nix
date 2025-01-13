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
    ProtectControlGroups = true;
    ProtectClock = true;
    ProtectKernelModules = true;
    PrivateMounts = true;
    PrivateIPC = true;
    RestrictSUIDSGID = true;
    RestrictRealtime = true;
    RestrictAddressFamilies = [ 
      "AF_UNIX"
      "AF_NETLINK"
      "AF_INET"
      "AF_INET6"
    ];
    SystemCallErrorNumber = "EPERM";
    SystemCallFilter = [
      "~@obsolete"
      "~@cpu-emulation"
      "~@clock"
      "~@swap"
      "~@module"
      "~@reboot"
      "~@raw-io"
      "~@debug"
    ];
    SystemCallArchitectures = "native";
    LockPersonality = true;
    IPAddressDeny = ["0.0.0.0/0" "::/0"];
    RestrictNamespaces = [ "~cgroup" ];
    CapabilityBoundingSet = [
      "CAP_SYS_ADMIN" 
      "CAP_SETUID"
      "CAP_SETGID"
      "CAP_KILL"
      "CAP_CHOWN"
      "CAP_SYS_TTY_CONFIG"
      "CAP_SETPCAP"
      "CAP_DAC_OVERRIDE"
      "CAP_DAC_READ_SEARCH"
      "CAP_FOWNER"
      "CAP_IPC_OWNER" 
      "CAP_FSETID"
      "CAP_SETFCAP"
    ];

    SupplementaryGroups = [ "tty" "input" "video" ];
    DeviceAllow = [
      "/dev/tty1" "rw"           # TTY for login (adjust to your setup)
      "/dev/tty7" "rw"           # Common TTY for graphical interface
      "/dev/dri/card*" "rw"      # GPU devices
      "/dev/dri/renderD128" "rw" # Render node
      "/dev/input/*" "r"         # Input devices
    ];
    DevicePolicy = "closed";
    UMask = 0077;
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
