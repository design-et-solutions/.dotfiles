{
  imports = [
    ./fish
  ];

  systemd.services."getty@tty1".serviceConfig = {
    NoNewPrivileges = true;
    ProtectHostname = true;
    RestrictRealtime = true;
  };
}
