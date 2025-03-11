{ pkgs, lib, ... }:
{
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ./ds.nix
  ];

  time.timeZone = "Europe/Paris";

  networking = {
    hostName = "r4-swr-trunk";
  };
}
