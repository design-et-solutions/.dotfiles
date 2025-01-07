{
  # Manage and grant real-time scheduling privileges to user-space processes.
  systemd.services.rtkit-daemon.serviceConfig = {
    NoNewPrivileges = true;

    ProtectSystem = "strict";
    ProtectHome = true;
    ProtectClock = true; 
    ProtectHostname = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectControlGroups = true; 
    ProtectProc = "invisible";

    PrivateTmp = true;
    PrivateMounts = true;
    PrivateDevices = true;

    RestrictNamespaces = true;
    RestrictSUIDSGID = true;
    RestrictAddressFamilies = [ 
      "~AF_INET6"  
      "~AF_INET"
      "~AF_PACKET"
    ];

    MemoryDenyWriteExecute = true;

    DevicePolicy = "closed";

    LockPersonality = true;

    SystemCallFilter = [
      "~@keyring"       # Deny kernel keyring operations
      "~@swap"          # Deny swap operations
      "~@clock"         
      "~@module"        # Deny kernel module options
      "~@obsolete"      # Deny system calls outdated, deprecated, or rarely used in modern Linux systems 
      "~@cpu-emulation" # Deny system calls that are related to CPU state manipulation or virtualization 
    ];
  }; 
}
