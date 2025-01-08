{
  # Handles reloading the configuration for the Linux virtual console (vconsole)
  systemd.services.reload-systemd-vconsole-setup.serviceConfig = {
    NoNewPrivileges = true;

    ProtectSystem = "strict";
    ProtectHome = true;
    ProtectClock = true; 
    ProtectHostname = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectProc = "invisible";

    PrivateTmp = true;
    PrivateMounts = true;
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

    DevicePolicy = "closed";

    LockPersonality = true;

    SystemCallFilter = [
      "~@keyring"       # Deny kernel keyring operations
      "~@swap"          # Deny swap operations
      "~@obsolete"      # Deny system calls outdated, deprecated, or rarely used in modern Linux systems 
      "~@cpu-emulation" # Deny system calls that are related to CPU state manipulation or virtualization 
    ];
    SystemCallArchitectures = "native";
  };

  # Prompts for a password or passphrase on the active virtual terminal (VT) where the user is logged in.
  systemd.services.systemd-ask-password-console.serviceConfig = {
    NoNewPrivileges = true;

    ProtectSystem = "strict";
    ProtectHome = true;
    ProtectClock = true; 
    ProtectHostname = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectProc = "invisible";

    PrivateTmp = true;
    PrivateMounts = true;
    PrivateNetwork = true;
    PrivateDevices = true;

    RestrictNamespaces = true;
    RestrictRealtime = true;
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

  # Display password prompts on all active virtual terminals (VTs) of a system. 
  systemd.services.systemd-ask-password-wall.serviceConfig = {
    NoNewPrivileges = true;

    ProtectSystem = "strict";
    ProtectHome = true;
    ProtectClock = true; 
    ProtectHostname = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectProc = "invisible";

    PrivateTmp = true;
    PrivateMounts = true;
    PrivateNetwork = true;
    PrivateDevices = true;

    RestrictNamespaces = true;
    RestrictRealtime = true;
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

  systemd.services.systemd-journald.serviceConfig = {
    NoNewPrivileges = true;

    ProtectProc = "invisible";

    ProtectHostname = true;
    PrivateMounts = true;
  };

  # Tracks and registers running "machines" (e.g., virtual machines or containers) in the system.
  systemd.services.systemd-machined.serviceConfig = {
    NoNewPrivileges = true;

    ProtectSystem = "strict";
    ProtectHome = true;
    ProtectClock = true; 
    ProtectHostname = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectProc = "invisible";

    PrivateTmp = true;
    PrivateMounts = true;
    PrivateUsers = true;
    PrivateNetwork = true;

    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    RestrictAddressFamilies = [ 
      "AF_UNIX"      # Socket family used for inter-process communication (IPC) 
    ];

    MemoryDenyWriteExecute = true;

    SystemCallArchitectures = "native";
  };

  # Manage the state of radio frequency (RF) devices (e.g., Wi-Fi, Bluetooth) persistently across reboots.
  systemd.services.systemd-rfkill.serviceConfig = {
    NoNewPrivileges = true;

    ProtectSystem = "strict";
    ProtectHome = true;
    ProtectKernelLogs = true;
    ProtectControlGroups = true;
    ProtectClock = true; 
    ProtectHostname = true;
    ProtectProc = "invisible";

    PrivateTmp = true;
    PrivateNetwork = true;
    PrivateUsers = true;

    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictAddressFamilies = [ 
      "AF_UNIX"      # Socket family used for inter-process communication (IPC) 
    ];
    RestrictSUIDSGID = true;

    MemoryDenyWriteExecute = true;

    SystemCallFilter = [
      "~@swap"          # Deny swap operations
      "~@obsolete"      # Deny system calls outdated, deprecated, or rarely used in modern Linux systems 
      "~@cpu-emulation" # Deny system calls that are related to CPU state manipulation or virtualization 
      "~@privileged"    # Deny privileged operations
    ];
    SystemCallArchitectures = "native";

    LockPersonality = true;

    CapabilityBoundingSet = [
      "~CAP_SYS_PTRACE" 
      "~CAP_SYS_PACCT"
    ];
  };

  # Responsible for managing device nodes in the /dev directory and handling dynamic device management events.
  systemd.services.systemd-udevd.serviceConfig = {
    NoNewPrivileges = true;

    ProtectSystem = "strict";
    ProtectHome = true;
    ProtectKernelLogs = true;
    ProtectControlGroups = true;
    ProtectClock = true; 
    ProtectProc = "invisible";

    RestrictNamespaces = true;

    CapabilityBoundingSet = "~CAP_SYS_PTRACE ~CAP_SYS_PACCT";
  };
}
