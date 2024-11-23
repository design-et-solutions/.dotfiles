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
    pkgs.linux-firmware
    (pkgs.runCommand "custom-brcmfmac-firmware" {
      buildInputs = [ pkgs.zstd ];
    } ''
      mkdir -p $out/lib/firmware/brcm

      # Copy firmware files
      cp ${pkgs.linux-firmware}/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.* $out/lib/firmware/brcm/

      # Decompress firmware files
      zstd -d $out/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.bin.zst -o $out/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.bin
      zstd -d $out/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.clm_blob.zst -o $out/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.clm_blob
      zstd -d $out/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.txt.zst -o $out/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.txt

      # Remove compressed files
      rm $out/lib/firmware/brcm/*.zst
    '')
  ];
}
