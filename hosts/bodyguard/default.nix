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

