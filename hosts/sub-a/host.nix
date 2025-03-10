# hosts/desktop-hood.nix
{ mkNixosConfiguration, nixos-hardware, ... }:

mkNixosConfiguration {
  system = "x86_64-linux";
  host = ./.;
  users = [ "me" ];
  setup = {
    gui = {
      enable = true;
    };
    can = {
      enable = true;
      peak = true;
    };
    nogui.network.wifi.emergency =  true;
  };
}
