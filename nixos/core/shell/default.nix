{
  imports = [
    ./fish
  ];

  systemd.services."autovt@tty1".serviceConfig = {
    NoNewPrivileges = true;
    MemoryDenyWriteExecute = true;
    LockPersonality = true; 
    ProtectHostname = true;
    RestrictRealtime = true;
    PrivateTmp = true;
    PrivateDevices = true;
    DevicePolicy= "closed";
  };
}
