{
  # Allowing system services to be managed in the context of a user's session rather than the system as a whole.
  systemd.services."user@".serviceConfig = {
    NoNewPrivileges = true;

    ProtectSystem = "full";
    # ProtectKernelModules = true;
    # ProtectControlGroups = true;
    # ProtectKernelTunables = true;
    # ProtectKernelLogs = true;
    # ProtectClock = true; 
    ProtectHostname = true;
    # PrivateDevices = true;

    PrivateTmp = true;
    PrivateNetwork = true;

    # SystemCallFilter = [
    #   "~@mount"      # Deny mounting operations
    #   "~@raw-io"     # Deny raw I/O operations
    #   "~@keyring"    # Deny kernel keyring operations
    # ];


    MemoryDenyWriteExecute = true;

    RestrictAddressFamilies = [ "AF_UNIX" ];
    RestrictNamespaces = true;

    # ReadOnlyPaths = [ "/etc" "/usr" ];

    # IPAddressDeny = "any";

    # LockPersonality = true;

    # DevicePolicy = "closed";


    CapabilityBoundingSet = [ ];  # Drop all capabilities if possible
    AmbientCapabilities = [ ]; # Ensure this is either not set or explicitly empty
  };
}
