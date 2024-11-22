{ pkgs, inputs, ... }:{
  environment.systemPackages = with pkgs; [ 
    lm_sensors 
  ];

  boot = {
    loader.grub.device = "nodev";
    kernelPackages = inputs.nix-rpi5.legacyPackages.aarch64-linux.linuxPackages_rpi5;
    # kernelModules = [ 
    #   "bcm2835_thermal" 
    #   "gpio-fan" "i2c-dev" 
    # ];
    # kernelParams = [
    #   "dtoverlay=rpi-poe"
    #   "dtparam=i2c_arm=on"
    #   "dtoverlay=gpio-fan,gpiopin=14,temp=55000"
    # ];
  };
}
