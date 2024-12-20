{ pkgs, lib, ... }:{
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];
  
  time.timeZone = "Europe/Paris";

  networking= {
    hostName = "bodyguard";
    wireguard = {
      interfaces = {
        wg0 = {
          peers = [
            {
              # desktop-hood
              publicKey = "fiwHXP5XpdiIy8qmV3hU4PbwMEiXyiS2M5EpEhFKywA=";
              allowedIPs = [ "10.100.0.2/32" ];
              persistentKeepalive = 25;
            }
            {
              # laptop-hood
              publicKey = "5vxIRcUsxCwK0KajAKKjWbW7ENH2Yka9khBtp4vS9Xk=";
              allowedIPs = [ "10.100.0.5/32" ];
              persistentKeepalive = 25;
            }
            {
              # project-handler
              publicKey = "JEXspdTfOxZ83z7tIcvUWN2Ir9nzsDUSA51tFB5002I=";
              allowedIPs = [ "10.100.0.4/32" ];
              persistentKeepalive = 25;
            }
          ];
        };
      };
    };
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

