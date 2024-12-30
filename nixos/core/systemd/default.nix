{
  systemd.services.systemd-ask-password-console.serviceConfig = {
    PrivateTmp = true;
    PrivateHome = true;
    NoNewPrivileges = true;
    PrivateDevices = true;
    DevicePolicy= "closed";
    ProtectKernelModules = true; 
    ProtectKernelTunables = true;
  };

  systemd.services.systemd-ask-password-wall.serviceConfig = {
    PrivateTmp = true;
    PrivateHome = true;
    NoNewPrivileges = true;
    PrivateDevices = true;
    DevicePolicy= "closed";
    ProtectKernelModules = true; 
    ProtectKernelTunables = true;
  };

  systemd.services.systemd-rfkill.serviceConfig = {
    PrivateTmp = true;
    PrivateHome = true;
    NoNewPrivileges = true;
    PrivateDevices = true;
    DevicePolicy= "closed";
    ProtectKernelModules = true; 
    ProtectKernelTunables = true;
  };

  systemd.services.reload-systemd-vconsole-setup.serviceConfig = {
    PrivateTmp = true;
    PrivateHome = true;
    NoNewPrivileges = true;
    ProtectHostname = true;
    RestrictRealtime = true;
  };

}
