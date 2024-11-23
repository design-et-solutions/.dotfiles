{ pkgs, inputs, lib, ... }:
{
  environment.systemPackages = with pkgs; [ 
    lm_sensors 
    zstd
  ];

  boot = {
    loader.grub.device = "nodev";
    kernelPackages = inputs.nix-rpi5.legacyPackages.aarch64-linux.linuxPackages_rpi5;
    loader.efi.canTouchEfiVariables = lib.mkForce false;
  };

  systemd.services.update-brcmfmac43455 = {
    description = ".update-brcmfmac43455 into /lib/firmware";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.bash}/bin/bash -c 'mkdir -p /lib/firmware/brcm && cp /nix/store/*-firmware/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.*.zst /lib/firmware/brcm/;  ${pkgs.zstd}/bin/zstd -d /lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.clm_blob.zst -o /lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.clm_blob; ${pkgs.zstd}/bin/zstd -d /lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.bin.zst -o /lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.bin; ${pkgs.zstd}/bin/zstd -d /lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.txt.zst -o /lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.txt; rm /lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.*.zst && modprobe -r brcmfmac && modprobe brcmfmac'";
      ExecStartPost = "${pkgs.coreutils}/bin/ls -l /lib/firmware/brcm";
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
}
