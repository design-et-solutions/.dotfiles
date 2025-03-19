{
  modulesPath,
  lib,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ../../nixos/disk-config.nix
  ];

  # services = {
  #   displayManager = {
  #     autoLogin.enable = true;
  #     autoLogin.user = "me";
  #   };
  # };

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
