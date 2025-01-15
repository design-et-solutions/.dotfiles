{
  programs.nix-ld.enable = true; # run unpatched dynamic binaries on NixOS

  # Daemon to perform store operations on behalf of non-root clients
  systemd.services.nix-daemon.serviceConfig = {
    NoNewPrivileges = true;
    ProtectControlGroups = true;
    ProtectHome = true;
    ProtectHostname = true;
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectKernelLogs = true;
    PrivateMounts = true;
    PrivateTmp = true;
    PrivateDevices = true;
    RestrictSUIDSGID = true;
    RestrictRealtime = true;
    RestrictAddressFamilies = [ 
      "AF_UNIX"
      "AF_NETLINK"
    ];
    RestrictNamespaces = true;
    SystemCallErrorNumber = "EPERM";
    SystemCallArchitectures = "native";
    SystemCallFilter = [
      "~@obsolete"
      "~@debug"
      "~@reboot"
      "~@swap"
      "~@cpu-emulation"
   ];
    LockPersonality = true;
    IPAddressDeny = ["0.0.0.0/0" "::/0"];
    MemoryDenyWriteExecute = true;
    DevicePolicy = "closed";
    UMask = 0077;
  };
}
