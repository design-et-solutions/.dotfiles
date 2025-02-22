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

  security.apparmor = {
    enable = true;
    packages = [ pkgs.apparmor-profiles ];
    enableCache = true;
    killUnconfinedConfinables = true;
  };
  security.apparmor.policies.display-manager = {
    profile = ''
      #include <tunables/global>

      profile display-manager flags=(complain) {
        #include <abstractions/base>
        
        /** rwmlkix,
        capability,
      }
    '';
    # profile = ''
    #   #include <tunables/global>
    #
    #   profile display-manager {
    #     #include <abstractions/base>
    #     #include <abstractions/nameservice>
    #     #include <abstractions/X>
    #     #include <abstractions/wayland>
    #
    #     /dev/** rwmk,
    #     /sys/** r,
    #     /proc/** r,
    #     /run/** rwk,
    #     /usr/** r,
    #     /etc/** r,
    #     /var/** rw,
    #     /home/** rw,
    #
    #     capability,
    #   }
    # '';
    state = "enforce";
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
    PrivatePIDs = false;
    PrivateUsers = false;

    RestrictSUIDSGID = true;
    RestrictRealtime = true;
    RestrictFileSystems = [ ];
    RestrictNamespaces = [
      "~cgroup"
      "uts"
      "pid"
      "net"
      "user"
      "mnt"
      "ipc"
    ];
    RestrictAddressFamilies = [
      "AF_UNIX"
      "AF_NETLINK"
      "AF_INET"
      "AF_INET6"
      "~AF_PACKET"
    ];

    SystemCallArchitectures = [
      # "native"
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
      "CAP_SYS_TTY_CONFIG"
      "CAP_DAC_OVERRIDE"
      "CAP_DAC_READ_SEARCH"
      "CAP_FOWNER"
      "CAP_IPC_OWNER"
      "CAP_FSETID"
      "CAP_SETFCAP"
      "CAP_CHOWN"
    ];
    AmbientCapabilities = [ ];

    DevicePolicy = "closed";
    DeviceAllow = [
      "/dev/tty7 rw"
      "/dev/input/* rw" # Allow Wayland to access keyboards/mice
      "/dev/dri/* rw" # Allow access to GPU devices
    ];

    LockPersonality = true;

    MemoryDenyWriteExecute = false;
    ProcSubset = "all";
    UMask = "0077";
    LogLevelMax = "debug";
    KeyringMode = lib.mkForce "private";
    IPAddressDeny = [
      "0.0.0.0/0"
      "::/0"
    ];
    AppArmorProfile = "display-manager";
  };
  # IPAddressAllow = [
  #   "127.0.0.1"
  #   "::1"
  # ];
  # IPAddressDeny = "any";
  # User = "root";
  # Group = "root";
  # RemoveIPC = true;
  # IPAddressAllow = [
  #   "127.0.0.1"
  #   "::1"
  # ];
  # AuditMode = "all";
  # "~@io-event"
  # "~@pkey"
  # "~@aio"
  # "~@basic-io"
  # "~@chown"
  # "~@file-system"
  # "~@io-event"
  # "~@ipc"
  # "~@keyring"
  # "~@memlock"
  # "~@network-io"
  # "~@process"
  # "~@sandbox"
  # "~@setuid"
  # "~@signal"
  # "~@sync"
  # "~@timer"
  # Personality = [ "x86" ];
  # DevicePolicy = "strict";
  # DeviceAllow = [
  #   "/dev/null rw"
  #   "/dev/zero rw"
  #   "/dev/random r"
  #   "/dev/urandom r"
  # ];
  # IPAddressAllow = "localhost";
  # AuditMode = "all";
  # IPAccounting = true;
  # ReadOnlyPaths = "/";
  # InaccessiblePaths = "/home /root";
  # LimitNOFILE = 1024;
  # LimitNPROC = 64;
  # LimitCORE = 0;

  environment.systemPackages = with pkgs; [
    brightnessctl # Command-line utility to control device brightness
  ];
}
