{ pkgs, ... }: {
  # https://search.nixos.org/options?channel=24.11&query=networking
  networking= {
    networkmanager = {
      enable = true;
    };
    # https://search.nixos.org/options?query=networking.firewall
    firewall = {
      enable = true;
      logRefusedConnections = true;
      allowedTCPPorts = [ 80 443 8080 ];
      allowedUDPPorts = [ 53 ];
    };
  };  

  systemd.services.NetworkManager.serviceConfig = {
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

  systemd.services.NetworkManager-dispatcher.serviceConfig = {
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

  # Managing wireless network connections
  systemd.services.wpa_supplicant.serviceConfig = {
    NoNewPrivileges = true;

    ProtectSystem = "strict";
    ProtectHome = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectKernelLogs = true;
    ProtectControlGroups = true;
    ProtectClock = true; 
    ProtectHostname = true;
    ProtectProc = "invisible";

    PrivateTmp = true;

    RestrictRealtime = true;
    # AF_INET    : Allow IPv4 internet protocol for regular network communication
    # AF_INET6   : Allow IPv6 internet protocol for regular network communication
    # AF_UNIX    : Allow Unix domain socket for local interprocess communication (IPC)
    # AF_NETLINK : Allow Netlink socket for interacting with the kernel's nl80211 interface
    # AF_PACKET  : Allow raw packet socket for direct packet-level operations
    RestrictAddressFamilies = "AF_INET AF_INET6 AF_UNIX AF_NETLINK AF_PACKET";
    RestrictNamespaces = true;
    RestrictSUIDSGID = true;

    MemoryDenyWriteExecute = true;

    ReadOnlyPaths = [ "/etc" "/usr" "/bin" "/sbin" ];

    InaccessiblePaths = [ "/home" "/root" "/run/user" ];

    SystemCallFilter = [
      "~@mount"      # Deny mounting operations
      "~@raw-io"     # Deny raw I/O operations
      "~@privileged" # Deny privileged operations
      "~@keyring"    # Deny kernel keyring operations
      "~@reboot"     # Deny rebooting operations
      "~@module"     # Deny kernel module options
      "~@debug"      # Deny debug operations
      "~@swap"       # Deny swap operations
      "ptrace"       # ALlow process tracing operations
    ];
    SystemCallArchitectures = "native";

    # Set of Linux capabilities that the service process and its child processes are allowed to retai
    # CAP_NET_ADMIN   : Allows a process to perform a wide range of privileged network-related operations
    # CAP_NET_RAW     : Allows sending and receiving raw packets
    CapabilityBoundingSet = "CAP_NET_ADMIN CAP_NET_RAW";
    # Provides a set of capabilities to the service that are available in its "ambient" capability set
    AmbientCapabilities = "CAP_NET_ADMIN CAP_NET_RAW";
  };

  programs.mtr.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  environment.systemPackages = with pkgs; [
    networkmanager   
    protobuf       
    nmap
    wget
    websocat
    curl
  ];
}
