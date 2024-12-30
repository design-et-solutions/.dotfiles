{
  # Manages user account information on Linux systems and is primarily used by graphical environments (e.g., GNOME) to provide an interface for managing user accounts
  systemd.services.accounts-daemon.serviceConfig = {
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
