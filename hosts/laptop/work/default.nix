{ config, lib, pkgs, ... }:
{
  imports = [
    ../../modules/common/users/me
    ../../modules/nixos/core
    ../../modules/nixos/optional/wifi/home
    ../../modules/home/optional/desktop/hyprland
  ];

  networking.hostName = "laptop-work";
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