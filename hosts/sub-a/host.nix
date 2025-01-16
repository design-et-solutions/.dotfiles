# hosts/desktop-hood.nix
{ mkNixosConfiguration, nixos-hardware, ... }:

mkNixosConfiguration {
  system = "intel64-linux";
  host = ./.;
  users = [ "me" ];
  setup = {
    gui = {
      enable = true;
    };
    nogui.network.wifi.emergency =  true;
  };
}
