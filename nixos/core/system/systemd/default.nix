{
  # Handles reloading the configuration for the Linux virtual console (vconsole)
  systemd.services.reload-systemd-vconsole-setup.serviceConfig = {
    # nonewprivileges = true;
    #
    # protectsystem = "strict"; # mounts everything read-only with the exception of /dev, /proc and /sys
    # protecthome = true;
    # protectkernelmodules = true; # prevents explicit kernel module loading
    # protectnetwork = true;
    # protectcontrolgroups = true; # protects the linux control groups from modification
    # protectkerneltunables = true; # prevents kernel tunables from being modified
    # protectkernellogs = true; # denies access to the kernel log ring buffer
    # protecthostname = true; # prevents the service from changing the hostname and/or react to changes of the hostname
    # protectclock = true; # denies all write requests to the hardware clock.
    #
    # restrictaddressfamilies = "af_unix af_inet af_inet6 af_netlink"; # restrict the available socket address families
    # restrictnamespaces = true; # access to namespacing functionality is restricted
    # restrictrealtime = true; # prevents the service from enabling realtime scheduling policies, which could be used to fully occupy the system
    # restrictsuidsgid = true; # prevents the setting of the suid or guid on files or directories
    #
    # privatetmp = true; # private directory for temporary files
    # privatedevices = true; # prevents access to physical devices
    # privateusers = true; # prevents the access to the home directories of other users
    #
    # devicepolicy= "closed"; # prevent access to physical devices unless explicitly allowed
    # memorydenywriteexecute = true; # prevents the creation or modification of memory mappings as executable
    # lockpersonality = true; # prevents the change of the personality settings for this process
    # capabilityboundingset = "~cap_linux_immutable cap_ipc_lock cap_sys_chroot cap_block_suspend cap_lease cap_sys_admin cap_sys_boot cap_sys_pacct cap_sys_ptrace cap_sys_rawio cap_sys_time cap_sys_tty_config cap_wake_alarm cap_mac_admin cap_mac_override cap_setuid cap_setgid cap_setpcap cap_chown cap_net_admin cap_fsetid cap_setfcap cap_dac_override cap_dac_read_search cap_fowner cap_ipc_owner"; # disables (via the ‘~’ sign) various potentially dangerous capabilities that this service doesn’t need anyway
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

    CapabilityBoundingSet = "~CAP_SYS_PTRACE ~CAP_SYS_PACCT";
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
