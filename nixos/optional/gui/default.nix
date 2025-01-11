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
    RestrictNamespaces = [ 
      "~cgroup"
      # "~ipc"
      # "~mnt"
      # "~net"
      # "~uts"
      # "~pid"

      # "~user"
    ];

    SystemCallFilter = [
      "~@obsolete"
      "~@cpu-emulation"
      "~@clock"
      "~@swap"
      "~@module"
      "~@reboot"
      "~@raw-io"
      "~@debug"
      # "~@resources"
      # "~@mount"
      # "~@privileged"
    ];
    SystemCallArchitectures = "native";

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
      "~CAP_BPF"
      "~CAP_LINUX_IMMUTABLE"

      # "~CAP_KILL"
      # "~CAP_SYSLOG"
      # "~CAP_LEASE"
      # "~CAP_IPC_LOCK"
      # "~CAP_SYS_TTY_CONFIG"
      # "~CAP_SYS_BOOT"
      # "CAP_SYS_CHROOT"
      # "CAP_BLOCK_SUSPEND"

      # "~CAP_NET_BIND_SERVICE"
      # "~CAP_NET_BROADCAST"
      # "~CAP_NET_RAW" 

      # ""
      # ""
    ];
    # LockPersonality = true;

    # ProcSubset = "pid";
    # DynamicUser = true;
    # UMask = "0022";
    # ProtectHostname = true;
    # NoNewPrivileges= true;
    # PrivateDevices = true;
    # ProtectKernelLogs = true;
    # MemoryDenyWriteExecute = true;
    # User = true;
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
