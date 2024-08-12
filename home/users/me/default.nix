{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Import general core 
    ../../core

    # Import optional
    ../../optional/pkgs/git
  ];

  home = {
    username = "me";
    homeDirectory = "/home/me";
  };

  users.users.me = {
    group = "me";
    isNormalUser = true;
    home = "/home/me";
  };

  home.packages = with pkgs; [ 
    can-utils
  ];
}
