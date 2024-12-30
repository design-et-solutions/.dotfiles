{
  services.dbus.enable = true;   # inter-process communication (IPC), allows apps to comm with one another

  systemd.services.dbus.serviceConfig = {
    ProtectSystem = "full";
    ProtectHome = true;
    PrivateTmp = true;
    PrivateDevices = true;
    DevicePolicy= "closed";
    ProtectKernelModules = true; 
    ProtectKernelTunables = true;
  };
}

