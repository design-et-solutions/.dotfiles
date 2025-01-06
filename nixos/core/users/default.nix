{
  # Allowing system services to be managed in the context of a user's session rather than the system as a whole.
  systemd.services."user@".serviceConfig = {
    NoNewPrivileges = true;

    ProtectSystem = "full";
    ProtectClock = true; 
    ProtectHostname = true;
    ProtectProc = "invisible";

    PrivateTmp = true;
    PrivateNetwork = true;

    MemoryDenyWriteExecute = true;

    RestrictAddressFamilies = [ "AF_UNIX" ];
    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;

    SystemCallArchitectures = "native";

    DevicePolicy = "closed";

    # NoExecPaths = [ "/tmp" "/var/tmp" ];
    # TemporaryFileSystem = [ "/var:ro" "/opt:ro" ];

    IPAddressDeny = "any";
    IPAddressAllow = [ "127.0.0.1" ];

    CapabilityBoundingSet = [ ];  # Drop all capabilities if possible
    AmbientCapabilities = [ ]; # Ensure this is either not set or explicitly empty
  };
}
