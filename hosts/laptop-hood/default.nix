{ pkgs, ... }:{
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  time.timeZone = "Europe/Paris";

  networking= {
    hostName = "laptop-hood";
    wg-quick = {
      interfaces = {
        wg0 = {
          address = [ "10.100.0.5/24" ];
        };
      };
    };
  };
}
