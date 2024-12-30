{ ... }:
{
  networking.wireless = {
    networks.Emergency = {
      psk = "%saveme%";
    };
  };

  systemd.services.emergency.serviceConfig = {
    # ProtectSystem = "strict";
    PrivateTmp = true;
    NoNewPrivileges = true;
    PrivateDevices = true;
    DevicePolicy= "closed";
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectKernelLogs = true;
  };
}
