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
      # ExecStart = "${pkgs.virtualbox}/bin/VirtualBox /home/me/VirtualBox\ VMs/synergy/synergy.vbox";
      # ExecStart = "${pkgs.virtualbox}/bin/VBoxManage startvm \"synergy\" --type headless && ${pkgs.virtualbox}/bin/VBoxManage controlvm \"synergy\" setcredentials \"synergy\" \"synergy\" \"domain\"";
      Restart = "always";
      RestartSec = "5s";
      Environment = [
        "WAYLAND_DISPLAY=wayland-1"
        "XDG_RUNTIME_DIR=/run/user/1000"
      ];
    };
  };
}
