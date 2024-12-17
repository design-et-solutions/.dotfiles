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
              # bodyguard
              publicKey = "fiwHXP5XpdiIy8qmV3hU4PbwMEiXyiS2M5EpEhFKywA=";
              allowedIPs = [ "10.100.0.2/32" ];
              persistentKeepalive = 25;
            }
            {
              # desktop-hood
              publicKey = "1bSJ9EnMTuFXulRmajkuPj8UZfUouwJvbE42ijIDOB4=";
              allowedIPs = [ "10.100.0.3/32" ];
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
    blocky = {
      enable = true;
      settings = {
        # Port for incoming DNS Queries.
        ports.dns = 53; 
        upstreams.groups.default = [
          # Using Cloudflare's DNS over HTTPS server for resolving queries.
          "https://one.one.one.one/dns-query" 
        ];
        # For initially solving DoH/DoT Requests when no system Resolver is available.
        bootstrapDns = {
          upstream = "https://one.one.one.one/dns-query";
          ips = [ "1.1.1.1" "1.0.0.1" ];
        };
        #Enable Blocking of certain domains.
        blocking = {
          denylists = {
            #Adblocking
            ads = ["https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"];
          };
          #Configure what block categories are used
          clientGroupsBlock = {
            default = [ "ads" ];
          };
        };
      };
    };
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

