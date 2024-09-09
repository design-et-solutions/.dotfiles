{ pkgs, lib, ... }:{
  # Boot configuration
  boot = {
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
      systemd-boot.enable = false;  # Explicitly disable systemd-boot
    };
    kernelPackages = pkgs.linuxPackages_rpi4;
    initrd.availableKernelModules = [ "usbhid" "usb_storage" ];
    # Increase if you experience kernel panics
    kernelParams = ["cma=128M"];
  };

  # File system configuration
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-label/FIRMWARE";
      fsType = "vfat";
    };
  };

  # Swap configuration (optional, but recommended)
  swapDevices = [ { device = "/swapfile"; size = 1024; } ];

  # Basic system packages
  environment.systemPackages = with pkgs; [
    raspberrypi-eeprom
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
  hardware.enableRedistributableFirmware = true;
  
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
    displayManager = {
      gdm = {
        autoLogin = {
          enable = true;
          user = "guest";
        };
      };
    };
  };
}
