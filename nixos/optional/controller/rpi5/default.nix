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

  # hardware.firmware = [
  #   pkgs.linux-firmware
  #   (pkgs.runCommand "custom-brcmfmac-firmware" {
  #     buildInputs = [ pkgs.${pkgs.zst}/bin/zstd pkgs.coreutils ];
  #   } ''
  #     mkdir -p $out/lib/firmware/brcm
  #
  #     # cp /nix/store/*-firmware/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.txt.zst $out/lib/firmware/brcm/
  #
  #     # sudo ${pkgs.zst}/bin/zstd -d /lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.clm_blob.zst -o /lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.clm_blob
  #     # sudo ${pkgs.zst}/bin/zstd -d /lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.txt.zst -o /lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.txt
  #     # sudo ${pkgs.zst}/bin/zstd -d /lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.bin.zst -o /lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.bin
  #
  #     cp ${pkgs.linux-firmware}/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.txt $out/lib/firmware/brcm/
  #     cp ${pkgs.linux-firmware}/lib/firmware/brcm/brcmfmac43455-sdio.clm_blob $out/lib/firmware/brcm/
  #     cp ${pkgs.linux-firmware}/lib/firmware/brcm/brcmfmac43455-sdio.bin $out/lib/firmware/brcm/
  #   '')
  # ];
  #
  # systemd.services.install-custom-firmware = {
  #   description = "Install custom firmware into /lib/firmware";
  #   wantedBy = [ "multi-user.target" ];
  #   serviceConfig = {
  #     ExecStart = "${pkgs.bash}/bin/bash -c 'cp -r $(readlink -f /nix/store/*custom-brcmfmac-firmware*/lib/firmware/brcm) /lib/firmware/'";
  #     ExecStartPost = "${pkgs.coreutils}/bin/ls -l /lib/firmware/brcm";
  #     Type = "oneshot";
  #     RemainAfterExit = true;
  #   };
  # };

  systemd.services.install-custom-firmware = {
    description = "Install custom firmware into /lib/firmware";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.bash}/bin/bash -c 'cp /nix/store/*-firmware/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.*.zst $out/lib/firmware/brcm/ && ${pkgs.zstd}/bin/zstd -d /lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.clm_blob.zst -o /lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.clm_blob && ${pkgs.zstd}/bin/zstd -d /lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.bin.zst -o /lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.bin && ${pkgs.zstd}/bin/zstd -d /lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.txt.zst -o /lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.txt'";
      ExecStartPost = "${pkgs.coreutils}/bin/ls -l /lib/firmware/brcm";
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
}
