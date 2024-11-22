{ pkgs, ... }:{
  environment.systemPackages = with pkgs; [ 
    lm_sensors 
  ];

  boot.kernelModules = [ "bcm2835_thermal" "gpio-fan" ];

  boot.kernelParams = [
    "dtoverlay=rpi-poe"
    "dtoverlay=gpio-fan,gpiopin=14,temp=55000"
  ];
}
