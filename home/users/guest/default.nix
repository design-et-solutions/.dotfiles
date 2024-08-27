{ pkgs, ... }: {
  imports = [
    # Import general core 
    ../../core

    # Import optional
    ../../optional/window-manager/hyprland
  ];

  home = {
    username = "guest";
    homeDirectory = "/home/guest";
  };
}
