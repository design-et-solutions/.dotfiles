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

    PrivateMounts = true;

    RestrictSUIDSGID = true;
    RestrictRealtime = true;
    RestrictAddressFamilies = [ 
      "AF_UNIX"      # Socket family used for inter-process communication (IPC) 
      "AF_NETLINK"   # Socket family used for communication between user-space applications and the Linux kernel
      "AF_INET"      # IPv4 internet protocol for regular network communication
      "AF_INET6"     # IPv6 internet protocol for regular network communication
      "AF_PACKET"    # Raw packet socket for direct packet-level operations
    ];

    SystemCallFilter = [
      "~@obsolete"
      "~@cpu-emulation"
      "~@clock"
      "~@swap"
      "~@module"
      "~@reboot"
    ];
    SystemCallArchitectures = "native";

    LockPersonality = true;

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
      
      # "~CAP_MKNOD"
      # "~CAP_LEASE"
      # "~CAP_BPF"
      # "~CAP_SYS_BOOT"
      # "~CAP_SYS_CHROOT"
      # "~CAP_BLOCK_SUSPEND"
    ];
    RestrictNamespaces = [ 
      # "~mnt"
      "~cgroup"
      "~user"
    ];
    # KeyringMode = "";
    # ProcSubset = ;
    # ProtectKernelTunables = true;
    # ProtectKernelModules = true;
    # ProtectKernelLogs = true;
    # ProtectProc = "invisible";
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
