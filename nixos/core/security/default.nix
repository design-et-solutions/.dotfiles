{ pkgs, ... }: {
  systemd.services.systemd-security-check = {
    description = "Run systemd security check and send notification";
    script = ''
      export PATH=${pkgs.coreutils}/bin:${pkgs.gawk}/bin:${pkgs.systemd}/bin:${pkgs.libnotify}/bin:$PATH
      echo $(systemd-analyze security | awk '/OK/ {ok++} {total++} END {print "OK: " ok " / Total: " total}')
    '';
    wantedBy = [ "multi-user.target" ];
  };

  systemd.timers.security-check = {
    description = "Daily systemd security check";
    timerConfig = {
      OnUnitActiveSec = "10sec";
      OnBootSec = "5min";
      # OnCalendar = "daily";
      Persistent = true;
    };
    wantedBy = [ "timers.target" ];
  };
}

