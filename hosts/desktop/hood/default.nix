{ pkgs, lib, ... }:{
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    # Import optional
    ../../../nixos/optional/drivers/gpu/nvidia
    ../../../nixos/optional/drivers/audio
    ../../../nixos/optional/network/wifi/home
    ../../../nixos/optional/pkgs/steam
    ../../../nixos/optional/pkgs/spotify
    ../../../nixos/optional/pkgs/python
  ];
  
  time.timeZone = "Europe/Paris";


  networking= {
    hostName = "desktop-hood";
    firewall.allowedTCPPorts = lib.mkAfter [ 3000 5000 ];
  };

  environment.systemPackages = with pkgs; [
    solaar    # Linux manager for many Logitech keyboards, mice, and other devices 
    steam-run # Steam env like
  ];
}
