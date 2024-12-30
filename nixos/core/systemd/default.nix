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

  # 
  systemd.services.systemd-rfkill.serviceConfig = {
    PrivateTmp = true;
    PrivateHome = true;
    NoNewPrivileges = true;
    PrivateDevices = true;
    DevicePolicy= "closed";
    ProtectKernelModules = true; 
    ProtectKernelTunables = true;
  };

  # Handles reloading the configuration for the Linux virtual console (vconsole)
  systemd.services.reload-systemd-vconsole-setup.serviceConfig = {
    PrivateTmp = true;
    PrivateHome = true;
    NoNewPrivileges = true;
    ProtectHostname = true;
    RestrictRealtime = true;
  };

  # Manages information about virtual machines (VMs), containers, and other machine instances running on the host
  systemd.services.systemd-machined.serviceConfig = {
    PrivateTmp = true;
    PrivateHome = true;
    NoNewPrivileges = true;
    ProtectHostname = true;
    RestrictRealtime = true;
    PrivateDevices = true;
    DevicePolicy= "closed";
    ProtectKernelModules = true; 
    ProtectKernelTunables = true;
    ProtectKernelLogs = true;
  };


}
