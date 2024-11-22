# hosts/desktop-hood.nix
{ mkNixosConfiguration, nixos-hardware, ... }:

mkNixosConfiguration {
  system = "aarch64-linux";
  host = ./.;
  users = [ "me" ];
  setup = {
    nogui = {
      network = {
        wifi = {
          emergency =  true;
        };
      };
    };
    controller = {
      rpi5 = true;
    };
  };
}
