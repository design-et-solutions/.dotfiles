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
      "cma=256M" 
      "dtoverlay=vc4-fkms-v3d"
      "snd_bcm2835.enable_headphones=1"
      "snd_bcm2835.enable_hdmi=1"
    ];
  };

  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  # Swap configuration (optional, but recommended)
  swapDevices = [ { device = "/swapfile"; size = 4096; } ];

  console.enable = false;
  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
    mesa
    mesa-demos

    wayland
    wlroots
    xwayland

    ffmpeg-full
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
  ];

  hardware = {
    raspberry-pi."4" = {
      apply-overlays-dtmerge.enable = true;
      fkms-3d.enable = true;
      # audio.enable = true;
    };
    deviceTree = {
      enable = true;
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
