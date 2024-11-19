# hosts/desktop-hood.nix
{ mkNixosConfiguration, nixos-hardware, ... }:

mkNixosConfiguration {
  system = "arrm64-linux";
  host = ./.;
  users = [ "bodyguard" ];
  setup = {};
}
