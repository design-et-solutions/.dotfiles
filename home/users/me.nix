{ pkgs, ... }: {
  home = {
    username = "me";
    homeDirectory = "/home/me";
  };

  programs.git = {
    enable = true;
    userName = "me";
    userEmail = "email@domain.com";
  };
}
