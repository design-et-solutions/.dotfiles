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
      autoLogin.enable = lib.mkDefault true;
      autoLogin.user = lib.mkDefault null;
    };
  };

  users.users.root.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMc6jbhoDuKt0YOIF9prT4reT9WG6sP2sEFVj59loQwq me@desktop-hood"
  ];

  disko.devices.disk.disk1.device = "/dev/nvme0n1";
}
