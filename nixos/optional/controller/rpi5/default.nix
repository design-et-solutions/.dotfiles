{ pkgs, inputs, lib, ... }:
{
  environment.systemPackages = with pkgs; [ 
    lm_sensors 
  ];

  boot = {
    loader.grub.device = "nodev";
    kernelPackages = inputs.nix-rpi5.legacyPackages.aarch64-linux.linuxPackages_rpi5;
    loader.efi.canTouchEfiVariables = lib.mkForce false;
  };

  hardware.firmware = [
    (pkgs.runCommand "rpi-firmware" { buildInputs = [ pkgs.wget ]; } ''
      mkdir -p /lib/firmware/brcm
      wget https://github.com/RPi-Distro/firmware-nonfree/blob/bookworm/debian/config/brcm80211/brcm/brcmfmac43455-sdio.bin -P /lib/firmware/brcm/brcmfmac43455-sdio.bin
      wget https://github.com/RPi-Distro/firmware-nonfree/blob/bookworm/debian/config/brcm80211/brcm/brcmfmac43455-sdio.txt -P /lib/firmware/brcm/brcmfmac43455-sdio.txt
    '')
  ];
}
