{ pkgs, lib, ... }:
let 
  name = "laptop-hood";
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
          address = [ "10.100.0.5/32" ];
        };
      };
    };
  };

  environment.etc."wireguard/wg0" = {
    source = builtins.toString ../../secrets/${name}/wg0;
    mode = "0400";
  };
}
