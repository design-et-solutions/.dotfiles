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
    initrd.availableKernelModules = [ "usbhid" "usb_storage" ];

    # Increase if you experience kernel panics
    kernelParams = [
      # "cma=128M" 
      "cma=256M" 
      "dtoverlay=vc4-fkms-v3d"
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
    (pkgs.buildFHSUserEnv {
      name = "fhs";
      targetPkgs = pkgs: with pkgs; [
        glibc
        zlib
        stdenv.cc.cc
      ];
      runScript = "bash";
    })
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
