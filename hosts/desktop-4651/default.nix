{ pkgs, lib, ... }:{
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];
  
  time.timeZone = "Europe/Paris";


  networking= {
    hostName = "desktop-4651";
  };

  networking.can.interfaces = {
    can0 = {
      bitrate = 500000;
    };
    can1 = {
      bitrate = 500000;
    };
  };

  services = { 
    xserver = {
      displayManager = {
        gdm = {
          autoLogin = {
            enable = true;
            user = "guest";
          };
        };
      };
    };
  };
}
