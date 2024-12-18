{ pkgs, ... }:{
  # Run to update virus databases 
  # > sudo freshclam
  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
  };

  systemd.services.clamav-scan = {
    description = "Run ClamAV Full System Scan";
    script = ''
      clamscan -r / --quiet --exclude-dir="^/sys" --exclude-dir="^/proc" --log=/var/log/clamav-scan.log
    '';
    wantedBy = [ "multi-user.target" ];
  };

  systemd.timers.clamav-scan-timer = {
    description = "Schedule Daily ClamAV System Scan";
    timerConfig.OnCalendar = "daily"; 
    wantedBy = [ "timers.target" ];
  };
}
