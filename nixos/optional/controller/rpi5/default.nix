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
      buildInputs = [ pkgs.zstd pkgs.coreutils ];
    } ''
      mkdir -p $out/lib/firmware/brcm

      # cp /nix/store/*-firmware/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.txt.zst $out/lib/firmware/brcm/
      # sudo zstd -d /lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.clm_blob.zst -o /lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.clm_blob

      # ls /nix/store/*-firmware/lib/firmware/brcm/

      # cp /nix/store/*-firmware/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.txt.zst $out/lib/firmware/brcm/ || echo "Failed to copy firmware"

      cp ${pkgs.linux-firmware}/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.txt $out/lib/firmware/brcm/

      # Remove compressed files
      rm $out/lib/firmware/brcm/*.zst
    '')
  ];
}
