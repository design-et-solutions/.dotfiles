{ pkgs, lib, ... }:
let 
  name = "bodyguard";
in {
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];
  
  time.timeZone = "Europe/Paris";

  networking= {
    hostName = name;
    wireguard = {
      interfaces = {
        wg0 = {
          peers = [
            {
              # desktop-hood
              publicKey = "cTtT4fNnJ4fgIsxRpwAPLQVd5iTD0SRt1QFxnFzQHi0=";
              allowedIPs = [ "10.100.0.2/32" ];
              persistentKeepalive = 25;
            }
            {
              # laptop-hood
              publicKey = "DeMeT8992rWF22jR2fMOVsDHaf3PqpqbpmHE3umweEk=";
              allowedIPs = [ "10.100.0.5/32" ];
              persistentKeepalive = 25;
            }
            {
              # project-handler
              publicKey = "bv2sLtWDO3V8N1Zug5EbI0Og+IMG9eNCVbF+GTlGoz4=";
              allowedIPs = [ "10.100.0.4/32" ];
              persistentKeepalive = 25;
            }
          ];
        };
      };
    };
  };

  environment.etc."wireguard/wg0" = {
    source = builtins.toString ../../secrets/${name}/wg0;
  };

  services = {
    # ntp.enable = true;
    # ntopng = {
    #   enable = true;
    #   listenAddress = "0.0.0.0:3000";
    # };
    # suricata = {
    #   enable = true;
    #   interface = "eth0"; 
    # };
  };
}

