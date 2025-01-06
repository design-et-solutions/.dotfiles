{
  # Allowing system services to be managed in the context of a user's session rather than the system as a whole.
  systemd.services."user@".serviceConfig = {
    NoNewPrivileges = true;

    ProtectSystem = "full";
    ProtectClock = true; 
    ProtectHostname = true;

    PrivateTmp = true;
    PrivateNetwork = true;

    MemoryDenyWriteExecute = true;

    RestrictAddressFamilies = [ "AF_UNIX" ];
    RestrictNamespaces = true;

    NoExecPaths = [ "/home" "/tmp" "/var/tmp" ];

    SystemCallArchitectures = "native";

    CapabilityBoundingSet = [ ];  # Drop all capabilities if possible
    AmbientCapabilities = [ ]; # Ensure this is either not set or explicitly empty
  };
}
