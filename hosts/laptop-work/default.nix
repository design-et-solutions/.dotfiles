{
  modulesPath,
  lib,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ../disk-config.nix
  ];

  services.displayManager.autoLogin = {
    enable = true;
    user = "me";
  };

  disko.devices.disk.disk1 = {
    device = "/dev/nvme0n1";
    # content.partitions.esp.content.mountpoint = "/boot/efi";
  };
}
