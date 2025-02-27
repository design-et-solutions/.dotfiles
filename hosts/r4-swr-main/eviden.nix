{ pkgs, ... }:
{
  virtualisation.virtualbox.host.enable = true;

  environment.systemPackages = with pkgs; [
    bash
    virtualbox
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-libav
  ];

  users.extraGroups.vboxusers.members = [ "me" ];
}
