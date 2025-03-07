{ pkgs, lib, ... }:
{
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ./ds.nix
    ./eviden.nix
    ./orange.nix
    # ./thales.nix
    ./test.nix
  ];

  time.timeZone = "Europe/Paris";

  networking = {
    hostName = "r4-swr-main";
    # hosts = {
    #   "192.100.1.1" = [ "cdp.thales" ];
    # };
    static = {
      routes = [
        {
          address = "192.100.1.0";
          prefixLength = 24;
          via = "192.168.100.1";
        }
      ];
    };
  };
}
