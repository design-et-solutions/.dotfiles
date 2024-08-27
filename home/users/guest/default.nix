{ pkgs, ... }: {
  imports = [
    # Import general core 
    ../../core

    # Import optional
  ];

  home = {
    username = "guest";
    homeDirectory = "/home/guest";
  };
}
