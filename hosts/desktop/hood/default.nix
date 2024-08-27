{ 
  pkgs,
  lib,
  ... 
}:
{
  imports = [
    # Import general core 
    ../../../nixos/core 
    
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    # Import optional
    ../../../nixos/optional/drivers/gpu/nvidia
    ../../../nixos/optional/drivers/audio
    ../../../nixos/optional/wifi/home 
    ../../../nixos/optional/wayland 
    ../../../nixos/optional/window-manager/hyprland 
    ../../../nixos/optional/pkgs/steam
    ../../../nixos/optional/pkgs/spotify
    ../../../nixos/optional/pkgs/python
  ];
  
  time.timeZone = "Europe/Paris";


  networking= {
    hostName = "desktop-hood";
    firewall.allowedTCPPorts = lib.mkAfter [ 3000 5000 ];
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;

  environment.systemPackages = with pkgs; [
    solaar    # Linux manager for many Logitech keyboards, mice, and other devices 
    steam-run # Steam env like
  ];

}
