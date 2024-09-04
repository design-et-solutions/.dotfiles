{ pkgs, ... }: {
  imports = [
    # Import optional
  ];

  home = {
    username = "me";
    homeDirectory = "/home/me";
  };

  home.packages = with pkgs; [ 
  ];

  programs.git = {
    enable = true;
    userName = "me";
    userEmail = "email@domain.com";
  };
}
