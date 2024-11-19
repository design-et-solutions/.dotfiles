{ pkgs, ... }: {
  home = {
    username = "bodyguard";
    homeDirectory = "/home/bodyguard";
  };

  programs.home-manager.enable = true;
}
