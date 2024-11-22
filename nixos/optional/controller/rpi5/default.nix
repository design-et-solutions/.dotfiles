{ pkgs, ... }:{
  environment.systemPackages = with pkgs; [ 
    lm_sensors 
    raspberrypi-tools
  ];

  boot = {
    loader.grub.device = "nodev";
    kernelPackages = (import (builtins.fetchTarball {
      url = "https://gitlab.com/vriska/nix-rpi5/-/archive/main.tar.gz";
      sha256 = "12110c0sbycpr5sm0sqyb76aq214s2lyc0a5yiyjkjhrabghgdcb";
    })).legacyPackages.aarch64-linux.linuxPackages_rpi5;
    kernelModules = [ 
      "bcm2835_thermal" 
      "gpio-fan" "i2c-dev" 
    ];
    kernelParams = [
      "dtoverlay=rpi-poe"
      "dtparam=i2c_arm=on"
      "dtoverlay=gpio-fan,gpiopin=14,temp=55000"
    ];
  };
}
