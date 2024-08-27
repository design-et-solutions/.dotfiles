{ pkgs, lib, ... }:{
  imports = [
    # Import general core 
    ../default.nix
    
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    # Import optional
    ../../../nixos/optional/pkgs/python
    ../../../nixos/optional/pkgs/steam

    # Import custom
  ];
  
  time.timeZone = "Europe/Paris";


  networking= {
    hostName = "desktop-work";
    firewall.allowedTCPPorts = lib.mkAfter [ 5000 ];
  };

  environment.systemPackages = with pkgs; [
    steam-run # Steam env like
  ];

  services.displayManager.autoLogin = {
    enable = true;
    user = "guest";
  };

}
