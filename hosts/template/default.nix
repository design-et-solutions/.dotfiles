{ config, lib, pkgs, ... }:
{
  imports = [
    ../../modules/nixos/core
  ];

  networking.hostName = "template";
}