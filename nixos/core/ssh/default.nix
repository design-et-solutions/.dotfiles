{ ... }: {
  services.openssh = {
    enable = true;
    ports = [ 2222 ];
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
      LogLevel = "VERBOSE";
    };
    extraConfig = ''
      # Limits the maximum number of authentication attempts per connection.
      MaxAuthTries 3
      # Limits the number of open sessions per SSH connection.
      MaxSessions 2
      # Determines whether the server sends TCP keepalive messages to ensure the connection is active.
      TCPKeepAlive no
      # Disables TCP forwarding during an SSH session, preventing the server from acting as a proxy.
      AllowTcpForwarding no
      # Disables SSH agent forwarding, which allows the client to forward its authentication agent to the server.
      AllowAgentForwarding no
      # Specifies the maximum number of client alive messages (heartbeats) sent by the server without receiving a response.
      ClientAliveCountMax 2
    '';
  };

  systemd.services.sshd.serviceConfig = {
    ProtectSystem = "strict"; # Mounts everything read-only with the exception of /dev, /proc and /sys
    ProtectHome = true;
    NoNewPrivileges = true;
    RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6 AF_NETLINK"; # Restrict the available socket address families
    PrivateTmp = true; # Private directory for temporary files
    PrivateDevices = true; # Prevents access to physical devices
    ProtectKernelModules = true; # Prevents explicit Kernel module loading
    DevicePolicy= "closed"; # Prevent access to physical devices unless explicitly allowed
    ProtectControlGroups = true; # Protects the Linux Control Groups from modification
    ProtectKernelTunables = true; # Prevents Kernel tunables from being modified
    RestrictNamespaces = true; # Access to namespacing functionality is restricted
    RestrictRealtime = true; # Prevents the service from enabling realtime scheduling policies, which could be used to fully occupy the system
    RestrictSUIDSGID = true; # Prevents the setting of the SUID or GUID on files or directories
    MemoryDenyWriteExecute = true; # Prevents the creation or modification of memory mappings as executable
    LockPersonality = true; # Prevents the change of the personality settings for this process
    PrivateUsers = true; # Prevents the access to the home directories of other users
    ProtectKernelLogs = true; # Denies access to the Kernel log ring buffer
    ProtectHostname = true; # Prevents the service from changing the hostname and/or react to changes of the hostname
    ProtectClock = false; # Denies all write requests to the hardware clock.

    CapabilityBoundingSet = "~CAP_LINUX_IMMUTABLE CAP_IPC_LOCK CAP_SYS_CHROOT CAP_BLOCK_SUSPEND CAP_LEASE CAP_SYS_ADMIN CAP_SYS_BOOT CAP_SYS_PACCT CAP_SYS_PTRACE CAP_SYS_RAWIO CAP_SYS_TIME CAP_SYS_TTY_CONFIG CAP_WAKE_ALARM CAP_MAC_ADMIN CAP_MAC_OVERRIDE CAP_SETUID CAP_SETGID CAP_SETPCAP CAP_CHOWN CAP_NET_ADMIN CAP_FSETID CAP_SETFCAP CAP_DAC_OVERRIDE CAP_DAC_READ_SEARCH CAP_FOWNER CAP_IPC_OWNER";
  };
}
