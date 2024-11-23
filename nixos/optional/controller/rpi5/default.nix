{ pkgs, inputs, lib, ... }:
let
  brcm_firmware_bin = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/RPi-Distro/firmware-nonfree/bookworm/debian/config/brcm80211/brcm/brcmfmac43455-sdio.bin";
    sha256 = "<INSERT_SHA256_FOR_BIN>";
  };

  brcm_firmware_txt = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/RPi-Distro/firmware-nonfree/bookworm/debian/config/brcm80211/brcm/brcmfmac43455-sdio.txt";
    sha256 = "<INSERT_SHA256_FOR_TXT>";
  };
in
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
    (pkgs.runCommand "rpi-firmware" { } ''
      mkdir -p $out/lib/firmware/brcm
      cp ${brcm_firmware_bin} $out/lib/firmware/brcm/brcmfmac43455-sdio.bin
      cp ${brcm_firmware_txt} $out/lib/firmware/brcm/brcmfmac43455-sdio.txt
    '')
  ];
}
