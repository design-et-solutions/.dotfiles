{ pkgs, ... }: {
  home = {
    username = "guest";
    homeDirectory = "/home/guest";
  };

  programs.git = {
    enable = true;
    userName = "guest";
    userEmail = "email@domain.com";
  };
}
