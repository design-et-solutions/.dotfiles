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

      # error
      # "~ipc"
      # "~mnt"
      # "~net"
      # "~uts"
      # "~pid"
      # "~user"
    ];

    CapabilityBoundingSet= [
      "~CAP_SYS_PACCT"
      "~CAP_SYS_MODULE"
      "~CAP_SYS_RAWIO"
      "~CAP_MAC_OVERRIDE"
      "~CAP_MAC_ADMIN"
      "~CAP_NET_BIND_SERVICE" 
      "~CAP_NET_BROADCAST"
      "~CAP_NET_RAW"
      "~CAP_SYS_NICE"
      "~CAP_SYS_RESOURCE"
      "~CAP_SYS_PTRACE"
      "~CAP_MKNOD"
      "~CAP_AUDIT_WRITE"
      "~CAP_AUDIT_READ"
      "~CAP_AUDIT_CONTROL"
      "~CAP_NET_ADMIN"
      # "~CAP_BPF"
      # "~CAP_IPC_LOCK"
      # "~CAP_LINUX_IMMUTABLE"

      # "~CAP_SYSLOG"

      # "~CAP_LEASE"
      # "~CAP_SYS_TTY_CONFIG"
      # "~CAP_SYS_BOOT"
      # "~CAP_SYS_CHROOT"
      # "~CAP_BLOCK_SUSPEND"
      #
      # "~CAP_NET_BIND_SERVICE"
      # "~CAP_NET_BROADCAST"
      # "~CAP_NET_RAW" 


      # error
      # "~CAP_DAC_*"
      # "~CAP_DAC_READ_SEARCH"
      # "~CAP_FOWNER"
      # "~CAP_IPC_OWNER"
      # "~CAP_KILL"
      # "~CAP_SETUID"
      # "~CAP_SETGID"
      # "~CAP_SETPCAP"
      # "~CAP_CHOWN"
      # "~CAP_FSETID"
      # "~CAP_SETFCAP"
      # "~CAP_SYS_ADMIN"
    ];
    # # IPAddressAllow = [
    # #   "192.168.10.0/24" 
    # #   "10.100.0.0/24" 
    # # ];
    #
    # #
    # # error
    # # ProtectKernelTunables = true;
    # # ProcSubset = "pid";
    # # ProtectProc = "noaccess";
    # # # ProtectProc = "invisible";
    # # # ProtectProc = "default";
    # # # ProtectProc = "ptraceable";
    # UMask = 0077;
    # MemoryDenyWriteExecute = true;
    # PrivateUsers = true;
    # ProtectHome = true;
    # ProtectKernelLogs = true;
    # DynamicUser = true;
    # NoNewPrivileges= true;
    # PrivateTmp = true;
    # ProtectHostname = true;
    # PrivateNetwork = true;
    # PrivateDevices = true;
    # User = true;
    # KeyringMode = "shared";
    # KeyringMode = "private";

    # PrivatePIDs = true;
    # MemoryKSM = true;

    # RemoveIPC=true;
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
