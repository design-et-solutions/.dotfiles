{ pkgs, ... }:
{
  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true;
  };

  boot.blacklistedKernelModules = [ "kvm_intel" ];
  users.extraGroups.vboxusers.members = [ "me" ];

  systemd.services."virtual-box-synergy" = {
    description = "Run Synergy VirtualBox";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "me";
      ExecStart = "${pkgs.virtualbox}/bin/VBoxHeadless --comment 'synergy' -startvm 'synergy' --vrde config";
      Restart = "always";
      RestartSec = "5s";
      Environment = "PATH=/run/current-system/sw/bin:/bin";
    };
  };
}
