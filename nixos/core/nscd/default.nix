{
  services.nscd = {
    enable = true;
  };

  systemd.services.nscd.serviceConfig = {
    ProtectSystem = "strict";
    PrivateTmp = true;
    NoNewPrivileges = true;
  };
}
