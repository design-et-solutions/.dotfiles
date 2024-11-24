{ pkgs, lib, ... }:{
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];
  
  time.timeZone = "Europe/Paris";

  environment.systemPackages = with pkgs; [
    iptables
    wireguard-tools
  ];

  networking= {
    hostName = "bodyguard";
    # Network Address Translation
    nat = {
      enable = true;
      externalInterface = "wlan0";
      internalInterfaces = [ "wg0" ];
    };
    wireguard = {
      interfaces = {
        wg0 = {
          ips = [ "10.100.0.1/24" ];
          postSetup = ''
            ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
          '';
          postShutdown = ''
            ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
          '';
          peers = [
            {
              publicKey = "fiwHXP5XpdiIy8qmV3hU4PbwMEiXyiS2M5EpEhFKywA=";
              allowedIPs = [ "10.100.0.2/32" ];
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

