{ config, lib, pkgs, ... }:
{
  boot.kernelParams = [
    "zswap.enabled=1"
    "zswap.compressor=lz4"        # lz4 is fast and provides good compression
    "zswap.max_pool_percent=20"   # Use up to 20% of RAM for zswap
    "zswap.zpool=z3fold"          # z3fold is a good choice for zswap
  ];

  # Optionally, you can set up some systemd services to monitor zswap usage
  systemd.services.zswap-monitor = {
    description = "Monitor zswap usage";
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.bash}/bin/bash -c 'while true; do echo $(date) $(cat /sys/kernel/debug/zswap/stat) >> /var/log/zswap.log; sleep 60; done'";
      Restart = "always";
    };
    wantedBy = [ "multi-user.target" ];
  };

  # Enable logging for zswap (optional)
  environment.etc."sysctl.d/99-zswap.conf".text = ''
    vm.swappiness = 60
    vm.vfs_cache_pressure = 50
  '';

  # Ensure the log directory exists
  environment.etc."logrotate.d/zswap".text = ''
    /var/log/zswap.log {
      daily
      missingok
      rotate 7
      compress
      delaycompress
      notifempty
      create 0640 root utmp
      sharedscripts
      postrotate
        systemctl reload rsyslog > /dev/null 2>&1 || true
      endscript
    }
  '';
}