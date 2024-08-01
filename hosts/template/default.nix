{ config, lib, pkgs, ... }:
{
  imports = [
    ../../modules/nixos/core 
    
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  networking.hostName = "template";
}