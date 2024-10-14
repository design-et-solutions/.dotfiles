{ pkgs, ... }: {
  home = {
    username = "me";
    homeDirectory = "/home/me";
  };

  programs.home-manager.enable = true;

  programs.git = {
    userName  = "Yves Cousteau";
    userEmail = "comandant.cousteau1997@gmail.com";
  };

}
