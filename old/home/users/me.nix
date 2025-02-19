{ pkgs, ... }: {
  home = {
    username = "me";
    homeDirectory = "/home/me";
  };

  programs.home-manager.enable = true;

  programs.git = {
    userName  = "TBF";
    userEmail = "tbf@gmail.com";
  };

}
