{ pkgs, ... }: {
  imports = [
    # Import general core 
    ../../core

    # Import optional
    ../../optional/window-manager/hyprland
    ../../optional/pkgs/git
    ../../optional/pkgs/lazygit
    ../../optional/pkgs/nvim
    ../../optional/pkgs/tmux
    ../../optional/pkgs/rust
    ../../optional/pkgs/firefox
    ../../optional/pkgs/unity
  ];

  home = {
    username = "me";
    homeDirectory = "/home/me";
  };

  home.packages = with pkgs; [ 
    can-utils # can cli tools
    vial      # keyboard soft
    stremio   # stream app
    woeusb    # tool to make boot key
  ];

  programs.git = {
    enable = true;
    userName = "me";
    userEmail = "email@domain.com";
  };
}
