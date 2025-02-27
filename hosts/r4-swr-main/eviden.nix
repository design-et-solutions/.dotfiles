{ pkgs, ... }:
{
  virtualisation = {
    # cores = 4;
    virtualbox.host = {
      enable = true;
      enableExtensionPack = true;
      # vtx = true;
    };
  };
  # virtualisation.qemu.options = [
  #   "-device virtio-vga"
  # ];

  boot.blacklistedKernelModules = [ "kvm_intel" ];

  environment.systemPackages = with pkgs; [
    # virtualbox
    bash
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-libav
    rpm
    rpmextract
  ];

  users.extraGroups.vboxusers.members = [ "me" ];

  # systemd.services."eviden-" = {
  #   description = "Run ";
  #   wantedBy = [ "multi-user.target" ];
  #   serviceConfig = {
  #     EnvironmentFile = [ ];
  #     ExecStartPre = "";
  #     ExecStart = "";
  #     ExecStartPost = "";
  #     Restart = "always";
  #     RestartSec = "5s";
  #   };
  # };
  #
  # systemd.services."eviden-" = {
  #   description = "Run ";
  #   wantedBy = [ "multi-user.target" ];
  #   serviceConfig = {
  #     EnvironmentFile = [ ];
  #     ExecStartPre = "";
  #     ExecStart = "";
  #     ExecStartPost = "";
  #     Restart = "always";
  #     RestartSec = "5s";
  #   };
  # };
  #
  # systemd.services."eviden-" = {
  #   description = "Run ";
  #   wantedBy = [ "multi-user.target" ];
  #   serviceConfig = {
  #     EnvironmentFile = [ ];
  #     ExecStartPre = "";
  #     ExecStart = "";
  #     ExecStartPost = "";
  #     Restart = "always";
  #     RestartSec = "5s";
  #   };
  # };
}
