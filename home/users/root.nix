{ pkgs, ... }:
{
  home = {
    username = "root";
    homeDirectory = "/home/root";
  };

  programs.home-manager.enable = true;
}
