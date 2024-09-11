{ pkgs, lib, ... }:{
  # Boot configuration
  boot = {
    loader = {
      systemd-boot.enable = lib.mkForce false;
      generic-extlinux-compatible.enable = lib.mkForce true;
      grub.enable = false;
      # generic-extlinux-compatible.enable = true;
      # systemd-boot.enable = false;  # Explicitly disable systemd-boot
    };
    kernelPackages = pkgs.linuxPackages_rpi4;
    initrd.availableKernelModules = [ "usbhid" "usb_storage" ];
    # Increase if you experience kernel panics
    kernelParams = [
      "cma=128M" 
      "dtoverlay=vc4-fkms-v3d"
    ];
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
  # swapDevices = [ { device = "/swapfile"; size = 2048; } ];

  console.enable = false;
  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
  ];

  # hardware.raspberry-pi."4".fkms-3d.enable = lib.mkForce false;
  hardware.raspberry-pi."4".fkms-3d.enable = true;
  # hardware.raspberry-pi."4".audio.enable = true;
  # hardware.raspberry-pi."4".dwc2.enable = true;
  hardware.enableRedistributableFirmware = true;
  hardware.raspberry-pi."4" = {
    gpu.memoryAllocated = 256;  # Increase GPU memory (in MB)
  };
  hardware.opengl = {
    enable = true;
    driSupport = true;
  };
  hardware = {
    raspberry-pi."4".apply-overlays-dtmerge.enable = true;
    deviceTree = {
      enable = true;
      filter = lib.mkForce "*rpi-4-*.dtb";
    };
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
