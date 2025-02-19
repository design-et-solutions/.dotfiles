{ pkgs, lib, ... }:
let
  name = "default-pc";
in
{
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  time.timeZone = "Europe/Paris";

  networking = {
    hostName = name;
  };
}
