{ pkgs, ... }: {
  environment.etc."scripts/systemd-analyzer-security.sh" = {
    source = builtins.toString ../../../scripts/systemd-analayser-security.sh;
    mode = "0755";
  };

  systemd.services.systemd-security-check = {
    description = "Run systemd security check";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c '/etc/scripts/systemd-analyzer-security.sh'";
      Environment = [
        "PATH=${pkgs.bash}/bin:${pkgs.gnugrep}/bin:${pkgs.gnused}/bin:${pkgs.coreutils}/bin:${pkgs.gawk}/bin:${pkgs.systemd}/bin:${pkgs.libnotify}/bin:${pkgs.procps}/bin:${pkgs.util-linux}/bin:$PATH"
      ];
    };
    wantedBy = [ "multi-user.target" ];
  };

  systemd.timers.systemd-security-check = {
    description = "Daily systemd security check";
    enable = true;
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "1h";
      Unit = "systemd-security-check.service";
      Persistent = true;
    };
    wantedBy = [ "timers.target" ];
  };
}
