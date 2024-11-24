{ pkgs, ... }:{
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ../bodyguard/vpn-client-ext.nix
  ];

  time.timeZone = "Europe/Paris";

  networking= {
    hostName = "laptop-hood";
    wireguard = {
      interfaces = {
        wg0 = {
          ips = [ "10.100.0.3/24" ];
        };
      };
    };
  };

  networking.can.interfaces = {
    can0 = {
      bitrate = 500000;
    };
    can1 = {
      bitrate = 500000;
    };
  };
}
