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

  services = {
    displayManager = {
      autoLogin.enable = true;
      autoLogin.user = "me";
    };
  };

  disko.devices.disk.disk1.device = "/dev/nvme0n1";

  # networking = {
  # wg-quick = {
  #   interfaces = {
  #     wg0 = {
  #       address = [ "10.100.0.2/32" ];
  #     };
  #   };
  # };
  # };

  # environment.etc."wireguard/wg0" = {
  #   source = builtins.toString ../../secrets/${name}/wg0;
  #   mode = "0400";
  # };
}
