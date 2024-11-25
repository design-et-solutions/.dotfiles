{ pkgs, inputs, lib, ... }:
{
  environment.systemPackages = with pkgs; [ 
    lm_sensors 
    zstd
    wayland
    wlroots
    xwayland
    hyprland
    sway
    weston
  ];

  boot = {
    loader.grub.device = "nodev";
    kernelPackages = inputs.nix-rpi5.legacyPackages.aarch64-linux.linuxPackages_rpi5;
    loader.efi.canTouchEfiVariables = lib.mkForce false;
    kernelParams = [ 
      # "cma=256M" 
      "dtoverlay=vc4-kms-v3d"
      # "dtoverlay=vc4-kms-v3d-pi5"
      # "gpu_mem=256"                  
    ];
    #  extraConfig = ''
    # '';
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

  # hardware = {
  #   opengl.enable = true;
  #   video.drivers = [ "modesetting" ]; # VC4 driver requires "modesetting"
  # };

   # Allocate memory for the GPU
}
