{
  pkgs,
  mergedSetup,
  lib,
  ...
}:
{
  imports = [
    ./hyprland.nix
    ./wayland.nix
  ];

  services = {
    xserver = {
      enable = true;
      displayManager = {
        gdm = {
          enable = true;
          wayland = true;
          banner = "go fuck your self";
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
    NoNewPrivileges = false;

    ProtectSystem = "full";
    ProtectControlGroups = true;
    ProtectClock = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = false;
    ProtectKernelTunables = false;
    ProtectHostname = false;
    ProtectProc = "default";
    ProtectHome = false;

    PrivateMounts = true;
    PrivateIPC = true;
    PrivateDevices = false;
    PrivateNetwork = false;
    PrivateTmp = false;
    # PrivatePIDs = true; # # lksdf?
    # PrivateUsers=

    RestrictSUIDSGID = true;
    RestrictRealtime = true;
    RestrictNamespaces = [
      "~cgroup"
      "ust"
      "pid"
      "net"
      "user"
      "mnt"
      "ipc"
    ];
    # RestrictFileSystems=
    RestrictAddressFamilies = [
      "AF_UNIX"
      "AF_NETLINK"
      "AF_INET"
      "AF_INET6"
      "~AF_PACKET"
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
    CapabilityBoundingSet = [
      "CAP_SYS_ADMIN"
      "CAP_SETUID"
      "CAP_SETGID"
      "CAP_SETPCAP"
      "CAP_KILL"
      # "CAP_SYS_TTY_CONFIG"
      "CAP_DAC_OVERRIDE"
      "CAP_DAC_READ_SEARCH"
      "CAP_FOWNER"
      "CAP_IPC_OWNER"
      "CAP_FSETID"
      "CAP_SETFCAP"
      "CAP_CHOWN"
    ];
    LockPersonality = true;
    IPAddressDeny = [
      "0.0.0.0/0"
      "::/0"
    ];
    IPAddressAllow = [ ];
    MemoryDenyWriteExecute = false;
    ProcSubset = "all";
    DeviceAllow = "/dev/tty7 rw";
    DevicePolicy = "closed";
    UMask = "0077";
    LogLevelMax = "debug";
    KeyringMode = lib.mkForce "private";
  };

  environment.systemPackages = with pkgs; [
    brightnessctl # Command-line utility to control device brightness
  ];
}
