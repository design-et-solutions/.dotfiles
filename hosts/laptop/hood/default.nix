{ 
  pkgs,
  ... 
}:
{
  imports = [
    # Import general core 
    ../../../nixos/core 
    ../../../nixos/core/shell/fish 
    
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    # Import optional
    ../../../nixos/optional/wifi/home 
    ../../../nixos/optional/wayland 
    ../../../nixos/optional/window-manager/hyprland 
    ../../../nixos/optional/pkgs/firefox
    ../../../nixos/optional/pkgs/tmux
    ../../../nixos/optional/pkgs/neovim
  ];

  networking.hostName = "laptop-hood";

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };
}
