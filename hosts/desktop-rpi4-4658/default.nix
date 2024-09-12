{ pkgs, lib, ... }:{
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  # Boot configuration
  boot = {
    loader = {
      generic-extlinux-compatible.enable = true;
      grub.enable = false;
      # systemd-boot.enable = lib.mkForce false;
      # generic-extlinux-compatible.enable = true;
      # systemd-boot.enable = false;  # Explicitly disable systemd-boot
    };
    kernelPackages = pkgs.linuxPackages_rpi4;
    initrd.availableKernelModules = [ "usbhid" "usb_storage" ];

    # Increase if you experience kernel panics
    kernelParams = [
      # "cma=128M" 
      "cma=256M" 
      "dtoverlay=vc4-fkms-v3d"
    ];
  };

  # File system configuration
  # fileSystems = {
  #   "/" = {
  #     device = "/dev/disk/by-label/NIXOS_SD";
  #     fsType = "ext4";
  #   };
  #   "/boot" = {
  #     device = "/dev/disk/by-label/FIRMWARE";
  #     # device = "/dev/disk/by-label/NIXOS_BOOT";
  #     fsType = "vfat";
  #   };
  # };

  # Swap configuration (optional, but recommended)
  # swapDevices = [ { device = "/swapfile"; size = 1024; } ];
  swapDevices = [ { device = "/swapfile"; size = 2048; } ];

  console.enable = false;
  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
    # glibc
    # glibc.dev
  ];

  hardware = {
    raspberry-pi."4" = {
      fkms-3d.enable = true;
    };
    enableRedistributableFirmware = true;
  };
  
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
      autoLogin = {
        enable = true;
        user = "guest";
      };
    };
  };
}
