{ ... }:
{
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
    NoNewPrivileges = false;

    ProtectSystem = "full";
    ProtectHome = false;
    ProtectClock = true;
    ProtectHostname = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectControlGroups = true;
    ProtectProc = "noaccess";

    PrivateTmp = true;
    PrivateMounts = true;
    PrivateDevices = true;
    PrivateIPC = true;
    PrivateNetwork = false;
    PrivatePIDs = true;
    PrivateUsers = false;

    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    # RestrictAddressFamilies = false;
    # RestrictAddressFamilies = [
    #   "~AF_UNIX"
    #   "~AF_NETLINK"
    #   "AF_INET"
    #   "AF_INET6"
    #   "~AF_PACKET"
    # ];

    SystemCallFilter = [
      "~@keyring"
      "~@swap"
      "~@clock"
      "~@module"
      "~@obsolete"
      "~@cpu-emulation"
      "~@debug"
    ];

    SystemCallArchitectures = "native";

    CapabilityBoundingSet = [
      "CAP_SYS_ADMIN"
      "CAP_SETUID"
      "CAP_SETGID"
      "CAP_SETPCAP"
      "CAP_KILL"
      "CAP_SYS_TTY_CONFIG"
      "CAP_DAC_OVERRIDE"
      "CAP_DAC_READ_SEARCH"
      "CAP_FOWNER"
      "CAP_IPC_OWNER"
      "CAP_FSETID"
      "CAP_SETFCAP"
      "CAP_CHOWN"
    ];
    AmbientCapabilities = [ ];

    MemoryDenyWriteExecute = true;
    LockPersonality = true;
    DevicePolicy = "closed";
  };

  # NoNewPrivileges = false;
  #
  # ProtectSystem = "full";
  # ProtectControlGroups = true;
  # ProtectClock = true;
  # ProtectKernelModules = true;
  # ProtectProc = "default";
  #
  # PrivateMounts = true;
  # PrivateIPC = true;
  #
  # RestrictSUIDSGID = true;
  # RestrictRealtime = true;
  # RestrictFileSystems = [ ];
  # RestrictNamespaces = [
  #   "~cgroup"
  #   "uts"
  #   "pid"
  #   "net"
  #   "user"
  #   "mnt"
  #   "ipc"
  # ];
  # RestrictAddressFamilies = [
  #   "AF_UNIX"
  #   "AF_NETLINK"
  #   "AF_INET"
  #   "AF_INET6"
  #   "~AF_PACKET"
  # ];
  #
  # SystemCallArchitectures = [ "native" ];
  # SystemCallErrorNumber = "EPERM";
  # SystemCallFilter = [
  #   "~@obsolete"
  #   "~@cpu-emulation"
  #   "~@clock"
  #   "~@swap"
  #   "~@module"
  #   "~@reboot"
  #   "~@raw-io"
  #   "~@debug"
  # ];
  #
  # CapabilityBoundingSet = [
  #   "CAP_SYS_ADMIN"
  #   "CAP_SETUID"
  #   "CAP_SETGID"
  #   "CAP_SETPCAP"
  #   "CAP_KILL"
  #   "CAP_SYS_TTY_CONFIG"
  #   "CAP_DAC_OVERRIDE"
  #   "CAP_DAC_READ_SEARCH"
  #   "CAP_FOWNER"
  #   "CAP_IPC_OWNER"
  #   "CAP_FSETID"
  #   "CAP_SETFCAP"
  #   "CAP_CHOWN"
  # ];
  # AmbientCapabilities = [ ];
  #
  # DevicePolicy = "closed";
  # DeviceAllow = [
  #   "/dev/tty7 rw"
  #   "/dev/input/* rw" # Allow Wayland to access keyboards/mice
  #   "/dev/dri/* rw" # Allow access to GPU devices
  # ];
  #
  # LockPersonality = true;
  # UMask = "077";
  # IPAddressDeny = "any";
  # KeyringMode = lib.mkForce "private";

}
