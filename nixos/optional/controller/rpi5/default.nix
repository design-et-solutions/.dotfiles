{ pkgs, inputs, ... }:{
  environment.systemPackages = with pkgs; [ 
    lm_sensors 
  ];

  boot = {
    loader.grub.device = "nodev";
    kernelPackages = inputs.nix-rpi5.legacyPackages.aarch64-linux.linuxPackages_rpi5;
    kernelModules = [ 
      "brcmfmac" 
    ];
    kernelParams = [
      "dtoverlay=disable-bt"
    ];
  };

  hardware = {
    enableAllFirmware = true;
    firmware = [ pkgs.linux-firmware ];
  };
}
