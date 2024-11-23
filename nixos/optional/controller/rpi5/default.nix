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

  systemd.services.copy-firmware = {
    description = "Decompress and copy firmware files for brcmfmac";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = ''
        ${pkgs.coreutils}/bin/mkdir -p /lib/firmware/brcm
        for firmware in ${pkgs.findutils}/bin/find /nix/store/*-firmware/lib/firmware/brcm/ -name '*.zst'; do
          target=$(${pkgs.coreutils}/bin/readlink -f "$firmware")
          ${pkgs.zstd}/bin/zstd -d "$firmware" -o "/lib/firmware/brcm/$(basename "$firmware" .zst)"
        done
      '';
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
}
