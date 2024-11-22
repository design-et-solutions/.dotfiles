{ pkgs, ... }:{
  environment.systemPackages = with pkgs; [ 
    lm_sensors 
  ];

  boot.kernelParams = [
    "dtoverlay=gpio-fan,gpiopin=14,temp=55000"
  ];
}
