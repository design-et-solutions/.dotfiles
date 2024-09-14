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
      # audio.enable = true;
      # video.disable = false;
    };
    deviceTree = {
      enable = true;
      filter = lib.mkForce "*rpi-4-*.dtb";
      # overlays = [
      #   {
      #     name = "vc4-kms-v3d";
      #     dtsText = ''
      #       /dts-v1/;
      #       /plugin/;
      #       / {
      #         compatible = "brcm,bcm2711";
      #         fragment@0 {
      #           target = <&vc4>;
      #           __overlay__ {
      #             status = "okay";
      #           };
      #         };
      #       };
      #     '';
      #   }
      # ];
    };
    enableRedistributableFirmware = true;
  };

  # qt.platformTheme = "gtk2";
  
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

  # security.polkit.enable = true;

  # xdg.portal = {
  #   enable = true;
  #   wlr.enable = true;
  #   extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  # };
  xserver = {
    enable = true;
    desktopManager = {
      gnome.enable = true;
    };
  };
}
