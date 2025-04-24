{ pkgs, lib, mergedSetup, ... }: {
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    consoleLogLevel = lib.mkDefault 4;
  };
}
