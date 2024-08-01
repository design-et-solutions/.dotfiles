{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Import general core 
    ../../core/

    # Import optional
    ../../optional/pkgs/git
    ../../optional/pkgs/neovim
  ];

  home = {
    username = "me";
    homeDirectory = "/home/me";
  };

  home.packages = with pkgs; [ 
      can-utils
  ];
}
