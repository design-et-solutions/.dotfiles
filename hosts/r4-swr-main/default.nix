{ pkgs, lib, ... }:
{
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ./ds.nix
    # ./eviden.nix
    # ./orange.nix
    # ./thales.nix
    # ./test.nix
  ];

  time.timeZone = "Europe/Paris";

  services.tailscale.enable = true;

  environment.systemPackages = [ pkgs.tailscale ];

  networking = {
    hostName = "r4-swr-main";
    hosts = {
      "192.1.1.1" = [ "cdp.thales" ];
    };
  };
}
