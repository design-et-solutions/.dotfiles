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
    # Common plugins like "filesrc" to combine within e.g. gst-launch
    gst_all_1.gst-plugins-base
    # Specialized plugins separated by quality
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    # Plugins to reuse ffmpeg to play almost every video format
    gst_all_1.gst-libav
    # Support the Video Audio (Hardware) Acceleration API
    gst_all_1.gst-vaapi
    mesa
    libva
    libva-utils
  ];

  environment.variables = {
    GST_PLUGIN_PATH = "${pkgs.gst_all_1.gstreamer}/lib/gstreamer-1.0";
    GST_PLUGIN_SYSTEM_PATH = "${pkgs.gst_all_1.gstreamer}/lib/gstreamer-1.0";
  };

  services.xserver.videoDrivers = [ "modesetting" ];

  # services.getty.autologin = {
  #   enable = true;
  #   user = "me"; 
  # };
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
