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
    userName = "username";
    userEmail = "email@domain.com";
  };
}
