{ ... }:{
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  time.timeZone = "Europe/Paris";

  networking= {
    hostName = "laptop-hood";
  };

  networking.can.interfaces = {
    can0 = {
      bitrate = 500000;
    };
    can1 = {
      bitrate = 250000;
    };
  };
}
