{
  # Allowing system services to be managed in the context of a user's session rather than the system as a whole.
  systemd.services."user@".serviceConfig = {
    # NoNewPrivileges = true;

    # ProtectSystem = "full";
    # ProtectClock = true; 
    # ProtectHostname = true;
    # ProtectProc = "invisible";

    # PrivateTmp = true;
    # PrivateNetwork = true;

    # MemoryDenyWriteExecute = true;

    RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" "AF_NETLINK" "AF_BLUETOOTH" ];
    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;

    SystemCallArchitectures = "native";

    CapabilityBoundingSet = [ ];
    AmbientCapabilities = [ ];
  };
}
