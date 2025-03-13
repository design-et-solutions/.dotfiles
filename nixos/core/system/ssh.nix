{ ... }:
{
  services.openssh = {
    enable = true;
    ports = [ 2222 ];
    settings = {
      PermitRootLogin = "prohibit-password"; # Allow root login only with SSH keys
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

    # ProtectSystem = "full";
    ProtectHome = false;
    ProtectClock = true;
    # ProtectHostname = true;
    # ProtectKernelTunables = true;
    # ProtectKernelModules = true;
    # ProtectKernelLogs = true;
    ProtectControlGroups = true;
    ProtectProc = "noaccess";

    PrivateTmp = true;
    PrivateMounts = true;
    PrivateDevices = true;
    PrivateIPC = true;
    PrivateNetwork = false;
    PrivatePIDs = true;
    PrivateUsers = false;

    # RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;

    SystemCallFilter = [
      # "~@reboot"
      "~@keyring"
      "~@swap"
      "~@clock"
      "~@module"
      "~@obsolete"
      "~@cpu-emulation"
      "~@debug"
    ];
    SystemCallArchitectures = "native";

    MemoryDenyWriteExecute = true;
    LockPersonality = true;
    DevicePolicy = "closed";
  };
}
