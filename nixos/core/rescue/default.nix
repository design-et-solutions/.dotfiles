{
  systemd.services.rescue.serviceConfig = {
    PrivateTmp = true;
    PrivateHome = true;
    NoNewPrivileges = true;
    PrivateDevices = true;
    DevicePolicy= "closed";
    ProtectKernelModules = true; 
    ProtectKernelTunables = true;
    ProtectKernelLogs = true;
    ProtectHostname = true;
  };
}
