{ pkgs, lib, ... }:{
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ../bodyguard/vpn-client-int.nix
  ];
  
  time.timeZone = "Europe/Paris";

  networking= {
    hostName = "project-handler";
    wireguard = {
      interfaces = {
        wg0 = {
          ips = [ "10.100.0.4/24" ];
        };
      };
    };
  };
}

