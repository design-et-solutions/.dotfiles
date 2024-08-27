{ pkgs, lib, ... }:
{
  imports = [
    # Import general core 
    ../../../nixos/core 
    
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    # Import optional
    ../../../nixos/optional/drivers/gpu/nvidia
    ../../../nixos/optional/drivers/audio
    ../../../nixos/optional/wayland 
    ../../../nixos/optional/window-manager/hyprland 
    ../../../nixos/optional/pkgs/python
    ../../../nixos/optional/pkgs/steam
  ];
  
  time.timeZone = "Europe/Paris";


  networking= {
    hostName = "desktop-work";
    firewall.allowedTCPPorts = lib.mkAfter [ 5000 ];
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  environment.systemPackages = with pkgs; [
    steam-run # Steam env like
  ];

  services.xserver.displayManager.autoLogin = {
    enable = true;
    user = "guest";
  };

}
