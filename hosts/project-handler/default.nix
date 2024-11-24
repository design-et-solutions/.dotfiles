{ pkgs, lib, ... }:{
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];
  
  time.timeZone = "Europe/Paris";

  networking= {
    hostName = "project-handler";
    wg-quick = {
      interfaces = {
        wg0 = {
          address = [ "10.100.0.4/24" ];
        };
      };
    };
  };
}

