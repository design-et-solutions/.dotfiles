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
        };
        # gdm = false;
        # startx.enable = true;
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
      "@mount"
    ];
    SystemCallArchitectures = "native";
    LockPersonality = true;
    IPAddressDeny = ["0.0.0.0/0" "::/0"];
    RestrictNamespaces = [ 
      "~cgroup" 
      "uts"
      "mnt"
      "pid"
      "net"
      "user"
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

    DeviceAllow = [
      "/dev/tty1" "rw"           # TTY for login
      "/dev/tty7" "rw"           # TTY for graphical interface 
      "/dev/dri/card*" "rw"      # GPU devices
      "/dev/dri/renderD128" "rw" # Render node
      "/dev/input/*" "r"          # Input devices (keyboard, mouse, etc.)
      "/dev/snd/*" "r"            # Audio devices (if sound is required)
      "/dev/rtc" "r"              # Real-Time Clock (needed for time-related operations)
    ];
    DevicePolicy = "closed";
    UMask = 0077;
    

    SecureBits = "keep-caps-locked no-setuid-fixup no-setuid-fixup-locked noroot-locked";
    ReadWritePaths = "/run /var/log/nginx";
    ExecPaths = "/usr/sbin/nginx /usr/lib";
    NoExecPaths = "/";
    InaccessiblePaths = "/dev/shm";
    CPUQuota = "100%";
    PrivatePIDs = true; 
    RemoveIPC = true;
    SocketBindDeny = "any";
    SocketBindAllow = [ "tcp:80" "tcp:443" "udp:443" ];
    RestrictFileSystems = [ "~devtmpfs" "~devpts" ];
    BindPaths = [ "/var/log" ];
    BindReadOnlyPaths = [ "/etc/passwd" "/etc/group" ];
    LimitNOFILE = 1024;
    LimitNPROC = 64;
    LimitMEMLOCK = "64M";
    ReadOnlyPaths = [ "/etc" "/usr" ];
    TemporaryFileSystem = "/var:ro";
    # IPAddressAllow = [ "localhost" "link-local" ];
    RestrictNetworkInterfaces = [ "lo" "eth0" "wlan0" ];

    # AAAAAAAAHHHHHHHHHHHH
    NoNewPrivileges = false;
    PrivateNetwork = false;
    PrivateDevices = false;
    PrivateTmp = false;
    PrivateUsers = false;
    ProtectProc = "default";
    ProtectKernelTunables = false;
    ProtectKernelLogs = false;
    ProtectHome = false;
    ProtectHostname = false;
    ProcSubset = "all";
    MemoryDenyWriteExecute = false;
    DynamicUser = false;
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
