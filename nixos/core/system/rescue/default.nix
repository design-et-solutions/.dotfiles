{
  # Boot a Linux system into rescue mode.
  systemd.services.rescue.serviceConfig = {
    NoNewPrivileges = true;

    ProtectSystem = "full";
    ProtectClock = true; 
    ProtectHostname = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectControlGroups = true; 
    ProtectProc = "invisible";

    PrivateTmp = true;
    PrivateNetwork = true;

    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    RestrictAddressFamilies = [ 
      "~AF_INET6"  
      "~AF_INET"
      "~AF_PACKET"
    ];

    MemoryDenyWriteExecute = true;

    LockPersonality = true;

    SystemCallFilter = [
      "~@swap"          # Deny swap operations
      "~@clock"         # Deny all system calls related to clock and timer management
      "~@obsolete"      # Deny system calls outdated, deprecated, or rarely used in modern Linux systems 
      "~@cpu-emulation" # Deny system calls that are related to CPU state manipulation or virtualization 
      "~@resources"
    ];
    SystemCallArchitectures = "native";

    CapabilityBoundingSet= [
      "~CAP_MAC_ADMIN"
      "~CAP_MAC_OVERRIDE"
      "~CAP_CHOWN"
      "~CAP_FSETID"
      "~CAP_SETFCAP"
    ];
  };
}
