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

    RestrictAddressFamilies = [ 
      "AF_UNIX"      # Socket family used for inter-process communication (IPC) 
      "AF_NETLINK"   # Socket family used for communication between user-space applications and the Linux kernel
      "AF_BLUETOOTH" # Socket family used for communication over Bluetooth
    ];
    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;

    SystemCallFilter = [
      "~@keyring"    # Deny kernel keyring operations
      "~@swap"       # Deny swap operations
      "~@debug"      # Deny debug operations
      "~@module"     # Deny kernel module options
      "~@obsolete"      # Deny system calls outdated, deprecated, or rarely used in modern Linux systems 
      "~@cpu-emulation" # Deny system calls that are related to CPU state manipulation or virtualization 
    ];
    SystemCallArchitectures = "native";

    # CapabilityBoundingSet = "~CAP_SYS_ADMIN";
  };
}
