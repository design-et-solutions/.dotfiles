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
    ../../optional/window-manager/hyprland
  ];

  home = {
    username = "me";
    homeDirectory = "/home/me";
  };

  home.packages = with pkgs; [ 
    can-utils
  ];
}
