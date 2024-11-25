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

    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good

    # Common plugins like "filesrc" to combine within e.g. gst-launch
    # Specialized plugins separated by quality
    # gst_all_1.gst-plugins-bad
    # gst_all_1.gst-plugins-ugly
    # Plugins to reuse ffmpeg to play almost every video format
    # gst_all_1.gst-libav
    # Support the Video Audio (Hardware) Acceleration API
    # gst_all_1.gst-vaapi

    mesa
    mesa-demos
    libva
    libva-utils
    ffmpeg
  ];

  environment.variables = {
    # GST_PLUGIN_PATH = "${pkgs.gst_all_1.gst-plugins-base}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-good}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-bad}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-ugly}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-libav}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-vaapi}/lib/gstreamer-1.0";
    # GST_PLUGIN_SYSTEM_PATH = "${pkgs.gst_all_1.gst-plugins-base}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-good}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-bad}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-ugly}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-libav}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-vaapi}/lib/gstreamer-1.0";
    GST_PLUGIN_SYSTEM_PATH="${gst_all_1.gst-plugins-base}/lib/gstreamer-1.0/:${gst_all_1.gst-plugins-good}/lib/gstreamer-1.0/";
    PATH="$PATH:${gst_all_1.gstreamer.dev}/bin";
  };

  services.xserver.videoDrivers = [ "modesetting" ];

  services.displayManager.autoLogin = {
    enable = true;
    user = "me";
  };

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
