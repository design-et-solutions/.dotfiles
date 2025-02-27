{ pkgs, lib, ... }:
{
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ./ds.nix
    ./eviden.nix
    ./orange.nix
    ./thales.nix
    ./test.nix
  ];

  time.timeZone = "Europe/Paris";

  networking = {
    hostName = "r4-swr-main";
  };
}
