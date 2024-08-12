{ pkgs, ... }:
{
  group = "me";
  isNormalUser = true;
  home = "/home/me";
  shell = pkgs.fish;
}
