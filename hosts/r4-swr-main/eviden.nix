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
      ExecStart = "${pkgs.virtualbox}/bin/VirtualBoxVM /home/me/VirtualBox\ VMs/synergy/synergy.vbox";
      Restart = "always";
      RestartSec = "5s";
      Environment = [
        "WAYLAND_DISPLAY=wayland-1"
        "XDG_RUNTIME_DIR=/run/user/1000"
      ];
    };
  };
}
