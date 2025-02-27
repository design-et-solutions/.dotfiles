{ pkgs, ... }:
{
  home = {
    username = "synergy";
    homeDirectory = "/home/synergy";
  };

  programs.home-manager.enable = true;

  programs.git = {
    userName = "TBF";
    userEmail = "tbf@gmail.com";
  };

}
