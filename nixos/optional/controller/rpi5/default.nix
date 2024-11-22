{ pkgs, ... }:{
  environment.systemPackages = with pkgs; [ 
    lm_sensors 
  ];

  boot.kernelModules = [ "bcm2835_thermal" "gpio-fan" "i2c-dev" ];

  boot.kernelParams = [
    "dtoverlay=rpi-poe"
    "dtparam=i2c_arm=on"
    "dtoverlay=gpio-fan,gpiopin=14,temp=55000"
  ];
}
