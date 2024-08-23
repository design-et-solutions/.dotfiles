{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    spotify
  ];

  networking.firewall.allowedTCPPorts = [ 
    57621  # to sync local tracks from your filesystem with mobile devices in the same network
    5353   # to enable discovery of Google Cast devices in the same network by the Spotify app
  ];
}
