{ pkgs, ... }: {
  home = {
    username = "me";
    homeDirectory = "/home/me";
  };

  programs.home-manager.enable = true;
}
