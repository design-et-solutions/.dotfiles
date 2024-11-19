{ pkgs, lib, ... }:{
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];
  
  time.timeZone = "Europe/Paris";


  networking= {
    hostName = "bodyguard";
    # Enable IP forwarding on the server
    enableIPv4Forwarding = true;
    # WireGuard is a modern, lightweight, and fast VPN
    # Encrypt and Secure Your Internet Traffic
    #   Privacy: Prevents your ISP, network admins, or attackers from seeing your internet activity.
    #   Security: Protects your data from being intercepted by encrypting all traffic.
    # Establish Secure Remote Access
    # Create a Private Network
    # Bypass Network Restrictions
    # Use as a Secure Gateway
    wireguard = {
      enable = true;
      interfaces = {
        # Generate Keys for WireGuard:
        # $wg genkey | tee /etc/wireguard/private.key | wg pubkey > /etc/wireguard/public.key
        wg0 = {
          # listens on for incoming connections
          listenPort = 51820;
          # IP address in the VPN's private network
          addresses = [ "10.0.0.1/24" ];
          privateKeyFile = "/etc/wireguard/private.key";
          # Defines the devices (clients) allowed to connect to the server
          peers = [
            # Each peer is identified by its publicKey and the allowedIPs it can use
            {
              # laptop
              publicKey = "peer-public-key";
              allowedIPs = [ "10.0.0.2/32" ];
            },
            {
              # desktop
              publicKey = "peer-public-key";
              allowedIPs = [ "10.0.0.3/32" ];
            },
            {
              # tv
              publicKey = "peer-public-key";
              allowedIPs = [ "10.0.0.4/32" ];
            },
            {
              # phone1
              publicKey = "peer-public-key";
              allowedIPs = [ "10.0.0.4/32" ];
            },
            {
              # phone2
              publicKey = "peer-public-key";
              allowedIPs = [ "10.0.0.5/32" ];
            },
            {
              # print
              publicKey = "peer-public-key";
              allowedIPs = [ "10.0.0.6/32" ];
            }
          ];
        };
      };
    };
    # allow VPN Port
    firewall = {
      allowedTCPPorts = [ 51820 ];
      allowedUDPPorts = [ 51820 ];  
    };
  };

  services = {
    pihole = {
      enable = true;
      extraConfig = ''
        BLOCKING_ENABLED=true
        BLOCKING_METHOD=IP-NODATA-AAAA
      '';
    };
    ntp.enable = true;
    ntopng = {
      enable = true;
      listenAddress = "0.0.0.0:3000";
    };
    suricata = {
      enable = true;
      interface = "eth0"; 
    };
  };
  
}

