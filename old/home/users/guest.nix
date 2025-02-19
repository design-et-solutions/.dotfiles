{ pkgs, ... }: {
  home = {
    username = "guest";
    homeDirectory = "/home/guest";
  };

  programs.home-manager.enable = true;
}
