{ pkgs, ... }:
{
  programs.spotify = {
    enable = true;
  };

  # to sync local tracks from your filesystem with mobile devices in the same network
  networking.firewall.allowedTCPPorts = [ 57621 ];

  # to enable discovery of Google Cast devices in the same network by the Spotify app
  networking.firewall.allowedTCPPorts = [ 5353 ];
}
