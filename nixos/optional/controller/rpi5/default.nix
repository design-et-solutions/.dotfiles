{ pkgs, inputs, lib, ... }:{
  environment.systemPackages = with pkgs; [ 
    lm_sensors 
  ];

  boot = {
    loader.grub.device = "nodev";
    kernelPackages = inputs.nix-rpi5.legacyPackages.aarch64-linux.linuxPackages_rpi5;
    loader.efi.canTouchEfiVariables = lib.mkForce false;
  };

  hardware.firmware = [
    (pkgs.runCommand "rpi-firmware" {} ''
      mkdir -p $out/lib/firmware/brcm
      curl -L -o $out/lib/firmware/brcm/brcmfmac43455-sdio.bin https://github.com/RPi-Distro/firmware-nonfree/raw/master/brcm/brcmfmac43455-sdio.bin
      curl -L -o $out/lib/firmware/brcm/brcmfmac43455-sdio.txt https://github.com/RPi-Distro/firmware-nonfree/raw/master/brcm/brcmfmac43455-sdio.txt
    '')
  ];
}
