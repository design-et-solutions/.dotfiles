# hosts/default.nix
{ mkNixosConfiguration, nixos-hardware, lib, ... }:

let
  # Get all subdirectories in the current directory
  hostDirs = lib.filterAttrs (n: v: v == "directory") (builtins.readDir ./.);

  # Function to deploy the WireGuard configuration
  deployWireGuardConfig = name: {
    environment.etc."wireguard/wg0" = {
      source = builtins.toString ../secrets + "/${name}/wg0";
      mode = "0600";
      owner = "root";
      group = "root";
    };
  };

  # deployWireGuardConfig = name: {
  #   systemd.tmpfiles.rules = [
  #     "d /etc/wireguard 0700 root root -"
  #     ''f+ /etc/wireguard/wg0 0600 root root - < "${toString ../secrets}/${name}/wg0"''
  #   ];
  # };

  # Import each host.nix file and create the configuration
  hostConfigurations = lib.mapAttrs (name: _: 
    import (./. + "/${name}/host.nix") { inherit mkNixosConfiguration nixos-hardware; }
  ) hostDirs;
in
  hostConfigurations
