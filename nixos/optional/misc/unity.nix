{ pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    unityhub # Official Unity game engine installer and project manager
  ];
}
