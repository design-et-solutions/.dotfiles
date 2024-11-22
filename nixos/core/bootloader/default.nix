{ ... }:
{
  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.efiSecBoot = true;
    efi.canTouchEfiVariables = true;
    timeout = 3;
    grub.efiSupport = true;
  };
}
