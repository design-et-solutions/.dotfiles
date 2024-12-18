{ ... }: {
  environment.etc."scripts/systemd-security-check.sh" = {
    source = ../../scripts/systemd-security-check.sh;
    executable = true;
    force = true;
  };

  systemd.services.systemd-security-check = {
    description = "Run systemd security check and send notification";
    script = "/etc/scripts/systemd-security-check.sh";
    wantedBy = [ "multi-user.target" ];
  };

  systemd.timers.security-check = {
    description = "Daily systemd security check";
    timerConfig = {
      OnUnitActiveSec = "10min";
      OnBootSec = "5min";
      # OnCalendar = "daily";
      Persistent = true;
    };
    wantedBy = [ "timers.target" ];
  };
}

