# # hosts/default.nix
# { mkNixosConfiguration, lib, ... }:
#
# let
#   # Get all .nix files in the current directory
#   hostFiles = lib.filterAttrs (n: v: v == "regular" && lib.hasSuffix ".nix" n) (builtins.readDir ./.);
#
#   # Remove the .nix extension from the filename
#   hostNames = lib.mapAttrs' (n: v: lib.nameValuePair (lib.removeSuffix ".nix" n) v) hostFiles;
#
#   # Import each host file and create the configuration
#   hostConfigurations = lib.mapAttrs (name: _: import (./. + "/${name}.nix") { inherit mkNixosConfiguration; }) hostNames;
# in
#   hostConfigurations
#

# hosts/default.nix
{ mkNixosConfiguration, lib, ... }:

let
  # Get all subdirectories in the current directory
  hostDirs = lib.filterAttrs (n: v: v == "directory" && n != "template") (builtins.readDir ./.);

  # Import each default.nix file and create the configuration
  hostConfigurations = lib.mapAttrs (name: _: 
    import (./. + "/${name}/default.nix") { inherit mkNixosConfiguration; }
  ) hostDirs;
in
  hostConfigurations

#   # hosts/default.nix
# { mkNixosConfiguration, lib, ... }:
#
# let
#   # Get all subdirectories in the current directory
#   hostDirs = lib.filterAttrs (n: v: v == "directory") (builtins.readDir ./.);
#
#   # Import each host.nix file and create the configuration
#   hostConfigurations = lib.mapAttrs (name: _: 
#     import (./. + "/${name}/host.nix") { inherit mkNixosConfiguration; }
#   ) hostDirs;
# in
#   hostConfigurations

# { mkNixosConfiguration, lib, ... }:
# {
#   desktop-hood = mkNixosConfiguration {
#     system = "x86_64-linux";
#     host = ./desktop_hood;
#     users = [ "me" ];
#     setup = {
#       gui = {
#         enable = true;
#         nvidia = true;
#         unity = true;
#         steam = true;
#         steam-run = true;
#         solaar = true;
#         streamio = true;
#         vial = true;
#         handbrake = true;
#         vlc = true;
#       };
#       audio = {
#         enable = true;
#         spotify = true;
#       };
#       network = {
#         wifi = {
#           home =  true;
#         };
#         bluetooth = false;
#         can = {
#           enable = false;
#           peak = false;
#         };
#       };
#     };
#     extraModules = [
#       ({ config, ... }: {
#         imports = [ ../projects/fatherhood ];
#         services.fatherhood = {
#           enable = true;
#           user = "1000";
#         };
#       })
#     ];
#   };
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
#   laptop-hood = mkNixosConfiguration {
#     system = "x86_64-linux";
#     host = ./laptop_hood;
#     users = [ "me" ];
#     setup = {
#       gui = {
#         enable = true;
#         nvidia = true;
#         unity = false;
#         steam = false;
#         steam-run = true;
#         solaar = true;
#         streamio = false;
#         vial = false;
#         handbrake = true;
#         vlc = true;
#       };
#       audio = {
#         enable = true;
#         spotify = true;
#       };
#       python = true;
#       network = {
#         wifi = {
#           home =  true;
#         };
#         bluetooth = true;
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
#           user = "1000";
#         };
#       })
#     ];
#   };
# }
