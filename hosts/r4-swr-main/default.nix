{ pkgs, lib, ... }:
{
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  time.timeZone = "Europe/Paris";

  networking = {
    hostName = "r4-swr-main";
  };

  services.xserver.displayManager = {
    autoLogin = {
      enable = true;
      user = "me";
    };
  };
}
