{
  services.nscd = {
    enable = true;
  };

  systemd.services.acpid.serviceConfig = {
    # ProtectSystem = "strict";
    PrivateTmp = true;
    PrivateHome = true;
    NoNewPrivileges = true;
  };
}
