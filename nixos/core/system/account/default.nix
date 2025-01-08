{
  # Managing and providing information about user accounts on a system.
  systemd.services.accounts-daemon.serviceConfig = {
    NoNewPrivileges = true;

    ProtectSystem = "strict";
    ProtectHome = true;
    ProtectProc = "invisible";
    ProtectHostname = true;
    ProtectKernelLogs = true;
    ProtectClock = true;

    PrivateTmp = true;

    RestrictSUIDSGID = true;

    SystemCallFilter = [
      "~@swap"
      "~@resources"
      "~@raw-io"
      "~@privileged"
      "~@mount"
      "~@module"
      "~@reboot"
      "~@debug"
      "~@cpu-emulation"
      "~@clock"
    ];
  };
}
