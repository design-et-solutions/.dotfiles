{ config, lib, pkgs, ... }:
{
  imports = [
    ../../../modules/nixos/core 
    ../../../modules/home/core
  ];

  networking.hostName = "template";
}