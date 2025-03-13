# hosts/default.nix
{ mkNixosConfiguration, lib, ... }:

let
  # Get all subdirectories in the current directory
  hostDirs = lib.filterAttrs (n: v: v == "directory") (builtins.readDir ./.);

  # Import each host.nix file and create the configuration
  hostConfigurations = lib.mapAttrs (
    name: _: import (./. + "/${name}/host.nix") { inherit mkNixosConfiguration; }
  ) hostDirs;
in
hostConfigurations
