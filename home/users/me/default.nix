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
    ../../optional/pkgs/nvim
    ../../optional/pkgs/tmux
    ../../optional/pkgs/firefox
    ../../optional/window-manager/hyprland
    ../../optional/fonts/zerox-proto
  ];

  home = {
    username = "me";
    homeDirectory = "/home/me";
  };

  home.packages = with pkgs; [ 
    can-utils # can cli tools
  ];
}
