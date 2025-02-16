{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    mvp # General-purpose media player, fork of MPlayer and mplayer2
  ];
}
