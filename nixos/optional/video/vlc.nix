{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vlc # Popular cross-platform media player
    libvlc # Core library for VLC
  ];
}
