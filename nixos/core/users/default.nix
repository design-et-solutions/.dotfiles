{
  # Allowing system services to be managed in the context of a user's session rather than the system as a whole.
  systemd.services."user@".serviceConfig = {
    ProtectSystem = "strict";
    ProtectClock = true; 
    ProtectHostname = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectProc = "invisible";

    PrivateTmp = true;
    PrivateNetwork = true;

    MemoryDenyWriteExecute = true;

    RestrictAddressFamilies = [ "AF_UNIX" "AF_NETLINK" "AF_BLUETOOTH" ];
    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;

    SystemCallFilter = [
      "~@keyring"    # Deny kernel keyring operations
      "~@swap"       # Deny swap operations
      "~@debug"      # Deny debug operations
      "~@module"     # Deny kernel module options
      # "~@raw-io"     # Deny raw I/O operations

      # "~@privileged" # Deny privileged operations
      # "~@mount"      # Deny mounting operations
      # "~@setuid"     # Prevent UID manipulation
      # "~@setpcap"

      # "~@exec"       # Prevent executing new processes
      # "~@fork"       # Prevent process creation
      # "~@clone"      # Prevent cloning processes or creating threads
      # "~@chroot"     # Prevent chroot operations
      # "~@mount"      # Prevent mounting filesystems
    ];
    SystemCallArchitectures = "native";

    CapabilityBoundingSet = [ ];
    AmbientCapabilities = [ ];

    # ReadOnlyPaths = [ "/etc" "/usr" "/var" "/home" ];  # Make /home read-only
    # ReadWritePaths = [ "/var/lib/service" ];  # Specific paths the service can write to
    #
    # LockPersonality = true;
    # RestrictUserNS = true;
    #
    # CPUQuota = "25%";         # Further restrict CPU usage
    # MemoryMax = "256M";       # Limit memory usage
    #
    # RestrictSockets = true;
    # RestrictNetworkNamespaces = true;

    # PrivateDevices = true;

    # MemoryLock = "0";
    # RestrictGroupNS = true;

    # IOAccounting = true;
    # BlockIOAccounting = true;

    # DevicePolicy = "strict";
  };
}
