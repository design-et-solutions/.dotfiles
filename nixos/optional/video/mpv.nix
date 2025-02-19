{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    mpv # General-purpose media player, fork of MPlayer and mplayer2
  ];
}
