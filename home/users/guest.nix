{ pkgs, ... }:
{
  home = {
    username = "guest";
    homeDirectory = "/home/guest";
  };

  programs.home-manager.enable = true;

  programs.git = {
    userName = "TBF";
    userEmail = "tbf@gmail.com";
  };
}
