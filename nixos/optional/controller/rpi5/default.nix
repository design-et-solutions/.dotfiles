{ pkgs, inputs, lib, ... }:{
  environment.systemPackages = with pkgs; [ 
    lm_sensors 
  ];

  boot = {
    loader.grub.device = "nodev";
    kernelPackages = inputs.nix-rpi5.legacyPackages.aarch64-linux.linuxPackages_rpi5;
    loader.efi.canTouchEfiVariables = lib.mkForce false;
  };

  hardware.firmware = [
    (pkgs.fetchzip {
      url = "https://github.com/RPi-Distro/firmware-nonfree/archive/refs/heads/master.zip";
      sha256 = "sha256-4WTrs/tUyOugufRrrh0qsEmhPclQD64ypYysxsnOyS8="; 
    })
  ];
}
