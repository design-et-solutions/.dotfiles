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
      ExecStart = "/run/wrappers/bin/VBoxHeadless --comment 'synergy' -startvm 'synergy' --vrde config";
      ExecStop = "/run/current-system/sw/bin/VBoxManage controlvm 'synergy' acpipowerbutton";
      Restart = "always";
      RestartSec = "5s";
    };
  };
}
