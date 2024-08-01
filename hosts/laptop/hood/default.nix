{ 
  pkgs,
  ... 
}:
{
  imports = [
    ../../../modules/nixos/core 
    
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    ../../../modules/nixos/optional/wifi/home 
    ../../../modules/nixos/optional/window-manager/wayland 
    ../../../modules/nixos/optional/window-manager/hyprland 
  ];

  networking.hostName = "laptop-hood";

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };
}