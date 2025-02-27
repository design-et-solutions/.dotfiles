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
      # Group = "vboxusers";
      # VBOX_USER_HOME = /home/me/.config/VirtualBox;
      # ExecStartPre = [
      # "${pkgs.kmod}/bin/modprobe vboxdrv"
      # "${pkgs.kmod}/bin/modprobe vboxnetflt"
      # "${pkgs.kmod}/bin/modprobe vboxnetadp"
      # ];
      # ExecStart = "${pkgs.virtualbox}/bin/VBoxHeadless --comment 'synergy' -startvm 'synergy' --vrde config";
      ExecStart = "/run/current-system/sw/bin/bash -l -c '${pkgs.virtualbox}/bin/VBoxHeadless --comment \"synergy\" -startvm \"synergy\" --vrde config'";
      Restart = "always";
      RestartSec = "5s";
      Environment = [
        "PATH=${pkgs.virtualbox}/bin:${pkgs.coreutils}/bin:/usr/bin:/bin"
      ];
    };
  };

  # services.udev.extraRules = ''
  # KERNEL=="vboxdrv", GROUP="vboxusers", MODE="0660"
  # '';
}
