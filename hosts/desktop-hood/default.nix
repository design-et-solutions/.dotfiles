{ pkgs, lib, ... }:
let 
  name = "desktop-hood";
in {
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];
  
  time.timeZone = "Europe/Paris";

  networking= {
    hostName = name;
    wg-quick = {
      interfaces = {
        wg0 = {
          address = [ "10.100.0.2/32" ];
        };
      };
    };
  };

  environment.etc."wireguard/wg0" = {
    source = builtins.toString ../../secrets/${name}/wg0;
  };
}

