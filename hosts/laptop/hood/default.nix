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
    ../../../nixos/optional/drivers/audio
    ../../../nixos/optional/drivers/bluetooth
    ../../../nixos/optional/wifi/home 
    ../../../nixos/optional/wayland 
    ../../../nixos/optional/window-manager/hyprland 
    ../../../nixos/optional/pkgs/spotify
    ../../../nixos/optional/pkgs/python
  ];

  system = "x86_64-linux";

  networking.hostName = "laptop-hood";

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };
}
