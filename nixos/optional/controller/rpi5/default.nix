{ pkgs, inputs, lib, ... }:
let
  brcm_firmware_bin = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/RPi-Distro/firmware-nonfree/bookworm/debian/config/brcm80211/brcm/brcmfmac43455-sdio.bin";
    sha256 = "0051d8bmhzna29wc9slp346ipvnckvr5lrhh4n7yfgvvxkbdgdg7";
  };

  brcm_firmware_txt = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/RPi-Distro/firmware-nonfree/bookworm/debian/config/brcm80211/brcm/brcmfmac43455-sdio.txt";
    sha256 = "0gcyrsirjx8j2481brps0ypxgjrsjhwlydrn569vdgbq3bl9nw6a";
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
