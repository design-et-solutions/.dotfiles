{ config, lib, pkgs, ... }:
{
  imports = [
    ../../../modules/nixos/core 
    ./hardware-configuration.nix
  ];

  networking.hostName = "template";
}