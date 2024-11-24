{ pkgs, lib, ... }:{
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];
  
  time.timeZone = "Europe/Paris";

  networking= {
    hostName = "desktop-hood";
    wg-quick = {
      interfaces = {
        wg0 = {
          address = [ "10.100.0.2/24" ];
        };
      };
    };
  };
}

