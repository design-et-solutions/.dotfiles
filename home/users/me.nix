{ pkgs, ... }: {
  imports = [
    # Import optional
    ../optional/pkgs/unity

    # Import projects
    ../../projects/fatherhood
  ];

  home = {
    username = "me";
    homeDirectory = "/home/me";
  };

  home.packages = with pkgs; [ 
    can-utils # can cli tools
    vial      # keyboard soft
    stremio   # stream app
  ];

  programs.git = {
    enable = true;
    userName = "me";
    userEmail = "email@domain.com";
  };
}
