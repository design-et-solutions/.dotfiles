{ pkgs, inputs, lib, ... }:
{
  environment.systemPackages = with pkgs; [ 
    lm_sensors 
    zstd

    # gui
    wayland
    wlroots
    xwayland
    hyprland
    sway
    weston
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
    gst-libav
    gstreamer-vaapi
  ];

  # to run gui
  # add to /boot/config.txt:
  #   dtoverlay=vc4-kms-v3d-pi5
  #   
  # $ git clone --depth=1 https://github.com/raspberrypi/firmware
  # $ sudo mkdir -p /boot/overlays
  # $ sudo cp firmware/boot/overlays/vc4-kms-v3d-pi5.dtbo /boot/overlays/

  boot = {
    loader.grub.device = "nodev";
    kernelPackages = inputs.nix-rpi5.legacyPackages.aarch64-linux.linuxPackages_rpi5;
    loader.efi.canTouchEfiVariables = lib.mkForce false;
    kernelParams = [];
  };

  systemd.services.update-brcmfmac43455 = {
    description = ".update-brcmfmac43455 into /lib/firmware";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.bash}/bin/bash -c 'mkdir -p /lib/firmware/brcm && cp /nix/store/*-firmware/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.*.zst /lib/firmware/brcm/;  ${pkgs.zstd}/bin/zstd -d /lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.clm_blob.zst -o /lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.clm_blob; ${pkgs.zstd}/bin/zstd -d /lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.bin.zst -o /lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.bin; ${pkgs.zstd}/bin/zstd -d /lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.txt.zst -o /lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.txt; rm /lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.*.zst && ${pkgs.kmod}/bin/modprobe  -r brcmfmac && ${pkgs.kmod}/bin/modprobe brcmfmac'";
      ExecStartPost = "${pkgs.coreutils}/bin/ls -l /lib/firmware/brcm";
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
}
