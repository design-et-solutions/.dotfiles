{ 
  config, 
  # lib, 
  pkgs,
  ... 
}:
{
  imports = [
    ../../../modules/nixos/core 
    
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    # ../../../modules/nixos/optional/wifi/home 
    # ../../../modules/home/optional/desktop/hyprland
  ];

  networking.hostName = "laptop-hood";

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  home.packages = with pkgs; [
    htop
  ];
}