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
      "AF_UNIX"      # Socket family used for inter-process communication (IPC) 
      "AF_NETLINK"   # Socket family used for communication between user-space applications and the Linux kernel
      "AF_INET"      # IPv4 internet protocol for regular network communication
      "AF_INET6"     # IPv6 internet protocol for regular network communication
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
    UMask = 0022;
    IPAddressDeny = ["0.0.0.0/0" "::/0"];

    RestrictNamespaces = [ 
      "~cgroup"
    ];

    CapabilityBoundingSet = [
      "CAP_SYS_ADMIN" 

      "CAP_SETUID"
      "CAP_SETGID"
      "CAP_SETPCAP"

      "CAP_DAC_OVERRIDE"
      "CAP_DAC_READ_SEARCH"
      "CAP_FOWNER"
      "CAP_IPC_OWNER"

      "CAP_KILL"

      "CAP_CHOWN"
      "CAP_FSETID"
      "CAP_SETFCAP"

      "CAP_SYS_TTY_CONFIG"
    ];
    # CapabilityBoundingSet= [
    #   "~CAP_SYS_PACCT"
    #   "~CAP_SYS_MODULE"
    #   "~CAP_SYS_RAWIO"
    #   "~CAP_MAC_OVERRIDE"
    #   "~CAP_MAC_ADMIN"
    #   "~CAP_NET_BIND_SERVICE" 
    #   "~CAP_NET_BROADCAST"
    #   "~CAP_NET_RAW"
    #   "~CAP_SYS_NICE"
    #   "~CAP_SYS_RESOURCE"
    #   "~CAP_SYS_PTRACE"
    #   "~CAP_MKNOD"
    #   "~CAP_AUDIT_WRITE"
    #   "~CAP_AUDIT_READ"
    #   "~CAP_AUDIT_CONTROL"
    #   "~CAP_NET_ADMIN"
    #   "~CAP_LEASE"
    #   "~CAP_SYS_BOOT"
    #
    #   # "~CAP_IPC_LOCK"
    #   # "~CAP_BPF"
    #   # "~CAP_LINUX_IMMUTABLE"
    #   # "~CAP_SYS_CHROOT"
    #   # "~CAP_BLOCK_SUSPEND"
    #
    #   # "~CAP_SYSLOG"
    #
    #   # "~CAP_IPC_LOCK"
    #   # "~CAP_BPF"
    #   # "~CAP_LINUX_IMMUTABLE"
    #   # "~CAP_SYS_TTY_CONFIG"
    #   # "~CAP_SYS_CHROOT"
    #   # "~CAP_BLOCK_SUSPEND"
    #   # "~CAP_NET_BIND_SERVICE"
    #   # "~CAP_NET_BROADCAST"
    #   # "~CAP_NET_RAW" 
    #
    #
    #   # "CAP_DAC_OVERRIDE"
    #   # "CAP_DAC_READ_SEARCH"
    #   # "CAP_FOWNER"
    #   # "CAP_IPC_OWNER"
    #   # "CAP_KILL"
    #   # "CAP_SETUID"
    #   # "CAP_SETGID"
    #   # "CAP_SETPCAP"
    #   # "CAP_CHOWN"
    #   # "CAP_FSETID"
    #   # "CAP_SETFCAP"
    #   # "CAP_SYS_ADMIN"
    # ];

    # ProtectKernelTunables = false;
    # ProcSubset = "all";
    # ProtectProc = "default";
    # MemoryDenyWriteExecute = false;
    # PrivateUsers = false;
    # ProtectHome = false;
    # ProtectKernelLogs = false;
    # DynamicUser = false;
    # NoNewPrivileges= false;
    # PrivateTmp = false;
    # ProtectHostname = false;
    # PrivateNetwork = false;
    # PrivateDevices = false;
    # KeyringMode = "shared";
    # DevicePolicy = "auto";
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
