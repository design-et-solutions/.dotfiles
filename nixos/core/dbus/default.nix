{
  systemd.services.dbus.serviceConfig = {
    ProtectSystem = "full";
    ProtectKernelModules = true;
    ProtectHome = true;
    PrivateTmp = true;
  };
}

