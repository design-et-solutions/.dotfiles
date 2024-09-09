{ pkgs, lib, nixos-hardware, ... }:{
  imports =
    [
      nixos-hardware.nixosModules.raspberry-pi-4
    ];
  hardware = {
    raspberry-pi."4".apply-overlays-dtmerge.enable = true;
    deviceTree = {
      enable = true;
      filter = "*rpi-4-*.dtb";
    };
  };
  console.enable = false;
  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
  ];

  hardware.raspberry-pi."4".fkms-3d.enable = true;
  
  time.timeZone = "Europe/Paris";

  networking= {
    hostName = "desktop-rpi4-4658";
  };

  networking.can.interfaces = {
    can0 = {
      bitrate = 250000;
    };
  };

  services = { 
    xserver = {
      displayManager = {
        gdm = {
          autoLogin = {
            enable = true;
            user = "guest";
          };
        };
      };
    };
  };
}
