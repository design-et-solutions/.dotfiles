{ pkgs, ... }: {
  home = {
    username = "bodyguard";
    homeDirectory = "/home/bodyguard";
  };

  programs.home-manager.enable = true;

  programs.git = {
    userName  = "YvesCousteau";
    userEmail = "45556867+YvesCousteau@users.noreply.github.com";
  };
}
