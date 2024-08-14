{ nixpkgs, ... }:
{
  group = "me";
  isNormalUser = true;
  home = "/home/me";
  shell = nixpkgs.fish;
}
