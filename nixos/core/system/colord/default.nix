{
  services.colord.enable = true;

  # Manages International Color Consortium (ICC) profiles.
  systemd.services.colord.serviceConfig = {
    NoNewPrivileges = true;

    ProtectSystem = "strict";
    ProtectHome = true;
    ProtectHostname = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectControlGroups = true; 
    ProtectProc = "invisible";

    PrivateTmp = true;

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
      "~@obsolete"      # Deny system calls outdated, deprecated, or rarely used in modern Linux systems 
      "~@cpu-emulation" # Deny system calls that are related to CPU state manipulation or virtualization 
      "~@mount"         # Deny mount operations
    ];
    SystemCallArchitectures = "native";

    CapabilityBoundingSet= [
      "~CAP_MAC_*"
      "~CAP_CHOWN"
      "~CAP_FSETID"
      "~CAP_SETFCAP"
    ];

  };
}
