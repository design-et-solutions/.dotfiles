{ pkgs, ... }: {
  imports = [
    # Import optional
  ];

  home = {
    username = "me";
    homeDirectory = "/home/me";
  };

  home.packages = with pkgs; [ 
    can-utils # can cli tools
  ];

  programs.git = {
    enable = true;
    userName = "me";
    userEmail = "email@domain.com";
  };
}
