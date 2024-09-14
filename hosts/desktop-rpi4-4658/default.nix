{ pkgs, lib, ... }:{
  # Boot configuration
  boot = {
    loader = {
      generic-extlinux-compatible.enable = true;
      grub.enable = false;
      systemd-boot.enable = lib.mkForce false;
      efi.canTouchEfiVariables = false;
    };
    kernelPackages = pkgs.linuxPackages_rpi4;
    initrd.availableKernelModules = [ "usbhid" "usb_storage" "xhci_pci" ];

    # Increase if you experience kernel panics
    kernelParams = [
      # "cma=128M" 
      # "cma=256M" 
      "cma=512M"
      # "dtoverlay=vc4-fkms-v3d"
      "dtoverlay=vc4-kms-v3d"
    ];
  };

  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  # Swap configuration (optional, but recommended)
  swapDevices = [ { device = "/swapfile"; size = 2048; } ];

  console.enable = false;
  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
  ];

  hardware = {
    raspberry-pi."4" = {
      apply-overlays-dtmerge.enable = true;
      fkms-3d.enable = true;
    };
    deviceTree = {
      # enable = true;
      filter = lib.mkForce "*rpi-4-*.dtb";
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
