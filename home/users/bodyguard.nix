{ pkgs, ... }: {
  home = {
    username = "bodyguard";
    homeDirectory = "/home/bodyguard";
  };

  programs.home-manager.enable = true;

  programs.git = {
    userName  = "Yves Cousteau";
    userEmail = "comandant.cousteau1997@gmail.com";
  };
}
