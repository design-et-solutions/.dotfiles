{ pkgs, ... }:
{
  extraGroups = [ "wheel" ];
  isSystemUser = true;
  home = "/home/root";
  shell = pkgs.fish;
}
