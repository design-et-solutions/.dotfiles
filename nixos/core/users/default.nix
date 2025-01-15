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
      "AF_UNIX" 
      "AF_NETLINK"
      "AF_BLUETOOTH"
    ];
    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    SystemCallFilter = [
      "~@keyring"
      "~@swap"
      "~@debug"
      "~@module"
      "~@obsolete" 
      "~@cpu-emulation" 
    ];
    SystemCallArchitectures = "native";
  };
}
