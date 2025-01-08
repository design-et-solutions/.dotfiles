{
  services.nscd = {
    enable = true;
  };

  # System daemon that provides a cache for common name service requests.
  systemd.services.nscd.serviceConfig = {
    ProtectClock = true; 
    ProtectHostname = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectControlGroups = true; 
    ProtectProc = "invisible";

    RestrictNamespaces = true;
    RestrictRealtime = true;

    MemoryDenyWriteExecute = true;

    LockPersonality = true;

    SystemCallFilter = [
      "~@mount"         # Deny mount operations
      "~@swap"          # Deny swap operations
      "~@clock"         # Deny all system calls related to clock and timer management
      "~@obsolete"      # Deny system calls outdated, deprecated, or rarely used in modern Linux systems 
      "~@cpu-emulation" # Deny system calls that are related to CPU state manipulation or virtualization 
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
