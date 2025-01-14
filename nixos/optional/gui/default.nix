{ pkgs, mergedSetup, lib, ... }:
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
    ProtectSystem = "full";
    ProtectControlGroups = true;
    ProtectClock = true;
    ProtectKernelModules = true;
    # error: this system does not support the kernel namespaces that are required for sandboxing; use '--no-sandbox' to disable sandboxing
    # ProtectKernelLogs = true;
    # error: this system does not support the kernel namespaces that are required for sandboxing; use '--no-sandbox' to disable sandboxing
    # ProtectKernelTunables = true;
    # error: this system does not support the kernel namespaces that are required for sandboxing; use '--no-sandbox' to disable sandboxing
    # ProtectHostname = true;
    # wont boot
    # ProtectProc = "invisible";
    # wont boot
    # ProtectHome = true;
    PrivateMounts = true;
    PrivateIPC = true;
    # no ethernet connection
    # PrivateNetwork = true;
    # wont boot
    # PrivateDevices = true;
    # wont boot
    # PrivateTmp = true;
    # wont boot
    # PrivateUsers = true;
    RestrictSUIDSGID = true;
    RestrictRealtime = true;
    RestrictNamespaces = [ 
      "~cgroup" 
      # error: unable to start build process
      # "~net"
      # error: this system does not support the kernel namespaces that are required for sandboxing; use '--no-sandbox' to disable sandboxing
      # "~pid"
      # error: unable to start build process
      # "~uts"
      # error: this system does not support the kernel namespaces that are required for sandboxing; use '--no-sandbox' to disable sandboxing
      # "~mnt"
      # warning: on firefox 
      # "~usr"
      # error: unable to start build process
      # "~ipc"
    ];
    # error: this system does not support the kernel namespaces that are required for sandboxing; use '--no-sandbox' to disable sandboxing
    # RestrictNamespaces = true;
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
      # /nix/store/wpy6n7slzp8wh48kyih3q407mn1c1c94-system-path/bin/nixos-rebuild: line 216:  3368 Bad system call         (core dumped) "$@"
      # "~@mount"
      # wont boot
      # "~@privileged"
      # wont boot
      # "~@resources"
      # wont boot
      # "~@known"
      # wont boot
      # "~@system-service"
      # can't open a window see if i should enable some services
      # "~@default"
      # "~@aio"
      # "~@basic-io"
      # "~@chown"
      # "~@file-system"
      # "~@io-event"
      # "~@ipc"
      # "~@keyring"
      # "~@memlock"
      # "~@network-io"
      # "~@pkey"
      # "~@process"
      # "~@sandbox"
      # "~@setuid"
      # "~@signal"
      # "~@sync"
      # "~@timer"
    ];
    SystemCallArchitectures = "native";
    LockPersonality = true;
    IPAddressDeny = ["0.0.0.0/0" "::/0"];
    CapabilityBoundingSet = [
      "CAP_SYS_ADMIN" 
      "CAP_SETUID"
      "CAP_SETGID"
      "CAP_SETPCAP"
      "CAP_KILL"
      #
      # "~CAP_KILL"
      "CAP_SYS_TTY_CONFIG"
      # wont boot
      # "~CAP_SYS_TTY_CONFIG"
      "CAP_DAC_OVERRIDE"
      # wont login
      # "~CAP_DAC_OVERRIDE"
      "CAP_DAC_READ_SEARCH"
      "CAP_FOWNER"
      "CAP_IPC_OWNER" 
      "CAP_FSETID"
      "CAP_SETFCAP"
      "CAP_CHOWN"
    ];
    DeviceAllow = [
      "/dev/tty7" "rw"           # TTY for graphical interface 
      # "/dev/tty1" "rw"           # TTY for login
      # "/dev/dri/card*" "rw"      # GPU devices
      # "/dev/dri/renderD128" "rw" # Render node
      # "/dev/input/*" "r"          # Input devices (keyboard, mouse, etc.)
      # "/dev/snd/*" "r"            # Audio devices (if sound is required)
      # "/dev/rtc" "r"              # Real-Time Clock (needed for time-related operations)
    ];
    DevicePolicy = "closed";
    UMask = 0077;
    # GC Warning: Could not open /proc/stat
    # ProcSubset = "pid";
    # wont boot
    # MemoryDenyWriteExecute = true;
    # wont boot
    # DynamicUser = true;
    LogLevelMax = "debug";
    KeyringMode = lib.mkForce "private";
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
