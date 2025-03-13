{ pkgs, lib, ... }:
{
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ./disko-config.nix
  ];

  time.timeZone = "Europe/Paris";
}
