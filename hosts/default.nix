# hosts/default.nix
{ mkNixosConfiguration, lib, ... }:

let
  # Get all subdirectories in the current directory
  hostDirs = lib.filterAttrs (n: v: v == "directory") (builtins.readDir ./.);

  # Import each host.nix file and create the configuration
  hostConfigurations = lib.mapAttrs (name: _: 
    import (./. + "/${name}/host.nix") { inherit mkNixosConfiguration; }
  ) hostDirs;
in
  hostConfigurations

#   desktop-4644 = mkNixosConfiguration {
#     system = "x86_64-linux";
#     host = ./desktop_4644;
#     users = [ "guest" ];
#     setup = {
#       gui = {
#         enable = true;
#         nvidia = true;
#         unity = false;
#         steam = false;
#         steam-run = false;
#         solaar = false;
#         streamio = false;
#         vial = false;
#         handbrake = false;
#         vlc = false;
#       };
#       audio = {
#         enable = true;
#         spotify = false;
#       };
#       network = {
#         wifi = {
#           home =  false;
#         };
#         bluetooth = false;
#         can = {
#           enable = true;
#           peak = true;
#         };
#       };
#     };
#     extraModules = [
#       ({ config, ... }: {
#         imports = [ ../projects/fatherhood ];
#         services.fatherhood = {
#           enable = true;
#           user = "1001";
#         };
#       })
#       ../projects/cantrolly
#       ../projects/sniffy
#       "/home/me/4644-ZDZ110/soft-high-level/nix/os.nix"
#     ];
#   };
