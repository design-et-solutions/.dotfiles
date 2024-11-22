{ pkgs, inputs, ... }:{
  environment.systemPackages = with pkgs; [ 
    lm_sensors 
  ];

  hardware = {
    firmware = with pkgs; [
      linux-firmware
    ];
  };

  boot = {
    loader.grub.device = "nodev";
    kernelPackages = inputs.nix-rpi5.legacyPackages.aarch64-linux.linuxPackages_rpi5;
    kernelModules = [ 
      "brcmfmac" 
    ];
  };
}
