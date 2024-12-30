{
  programs.nix-ld.enable = true; # run unpatched dynamic binaries on NixOS

  systemd.services.nix-daemon.serviceConfig = {
    PrivateTmp = true;
    PrivateHome = true;
    NoNewPrivileges = true;
    ProtectKernelModules = true; 
    ProtectKernelTunables = true;
    ProtectKernelLogs = true;
    ProtectHostname = true;
  };
}
