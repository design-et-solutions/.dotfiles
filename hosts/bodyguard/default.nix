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
              publicKey = "fiwHXP5XpdiIy8qmV3hU4PbwMEiXyiS2M5EpEhFKywA=";
              allowedIPs = [ "10.100.0.2/32" ];
              persistentKeepalive = 25;
            }
            {
              publicKey = "1bSJ9EnMTuFXulRmajkuPj8UZfUouwJvbE42ijIDOB4=";
              allowedIPs = [ "10.100.0.3/32" ];
              persistentKeepalive = 25;
            }
            {
              publicKey = "JEXspdTfOxZ83z7tIcvUWN2Ir9nzsDUSA51tFB5002I=";
              allowedIPs = [ "10.100.0.4/32" ];
              persistentKeepalive = 25;
            }
          ];
        };
      };
    };
  };

  # services = {
    # pihole = {
    #   enable = true;
    #   extraConfig = ''
    #     BLOCKING_ENABLED=true
    #     BLOCKING_METHOD=IP-NODATA-AAAA
    #   '';
    # };
    # ntp.enable = true;
    # ntopng = {
    #   enable = true;
    #   listenAddress = "0.0.0.0:3000";
    # };
    # suricata = {
    #   enable = true;
    #   interface = "eth0"; 
    # };
  # };
  
}

