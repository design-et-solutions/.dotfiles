{
  programs.nix-ld.enable = true; # run unpatched dynamic binaries on NixOS

  systemd.services.nix-daemon.serviceConfig = {
    # PrivateTmp = true;
    # PrivateHome = true;
    NoNewPrivileges = true;
    MemoryDenyWriteExecute = true;
    LockPersonality = true; 
    ProtectHostname = true;
    RestrictRealtime = true;
    PrivateTmp = true;
    PrivateDevices = true;
    DevicePolicy= "closed";
    # ProtectKernelModules = true; 
    # ProtectKernelTunables = true;
    # ProtectKernelLogs = true;
  };
}
