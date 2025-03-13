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
    NoNewPrivileges = true;

    ProtectSystem = false;
    ProtectHome = true;
    ProtectClock = true;
    ProtectHostname = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    ProtectControlGroups = true;
    ProtectProc = "noaccess";

    # PrivateTmp = true;
    # PrivateMounts = true;
    # PrivateDevices = true;
    # PrivateIPC = false;
    # PrivateNetwork = false;
    # PrivatePIDs = true;
    # PrivateUsers = true;

    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    RestrictAddressFamilies = [
      "~AF_UNIX"
      "~AF_NETLINK"
      "AF_INET"
      "AF_INET6"
      "~AF_PACKET"
    ];

    SystemCallFilter = [
      "~@keyring"
      "~@swap"
      "~@clock"
      "~@module"
      "~@obsolete"
      "~@cpu-emulation"
    ];
    SystemCallArchitectures = "native";

    MemoryDenyWriteExecute = true;
    LockPersonality = true;
    DevicePolicy = "closed";
  };
}
