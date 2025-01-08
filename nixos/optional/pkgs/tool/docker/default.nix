{ ... }:{
  virtualisation.docker.enable = true;

  systemd.services.docker.serviceConfig = {
    NoNewPrivileges = true;

    ProtectSystem = "full";
    ProtectHome = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectControlGroups = true; 
    ProtectClock = true;
    ProtectProc = "invisible";

    PrivateTmp = true;
    PrivateMounts = true;

    RestrictRealtime = true;
    RestrictAddressFamilies = [ 
      "AF_UNIX"
      "AF_NETLINK"
      "AF_INET" 
      "AF_INET6" 
    ];
    RestrictNamespaces = [
      "~user"
    ];

    MemoryDenyWriteExecute = true;

    SystemCallFilter = [
      "~@debug"
      "~@raw-io"
      "~@reboot"
      "~@clock"         # Deny clock operations
      "~@module"        # Deny kernel operations
      "~@swap"          # Deny swap operations
      "~@obsolete"      # Deny system calls outdated, deprecated, or rarely used in modern Linux systems 
      "~@cpu-emulation" # Deny system calls that are related to CPU state manipulation or virtualization 
    ];
    SystemCallArchitectures = "native";

    CapabilityBoundingSet= [
      "~CAP_SYS_RAWIO"
      "~CAP_SYS_PTRACE"
      "~CAP_SYS_BOOT"
    ];
  };
}
