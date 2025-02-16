{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wireguard-tools # Command-line tools for configuring WireGuard VPN tunnels
  ];

  networking = {
    firewall = {
      allowedUDPPorts = [ 51820 ];
    };
  };
}
