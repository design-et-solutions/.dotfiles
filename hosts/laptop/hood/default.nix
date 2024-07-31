{ config, lib, pkgs, ... }:
{
  imports = [
    ../../modules/nixos/core
    ../../modules/home/core
    ../../modules/nixos/optional/wifi/home
    ../../modules/home/optional/desktop/hyprland
  ];

  networking.hostName = "laptop-hood";

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  hardware.cpu.intel.updateMicrocode = true;

  home.packages = with pkgs; [
    htop
  ];
}