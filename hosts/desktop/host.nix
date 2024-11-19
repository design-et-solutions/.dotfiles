# hosts/desktop-hood.nix
{ mkNixosConfiguration, nixos-hardware, ... }:

mkNixosConfiguration {
  system = "x86_64-linux";
  host = ./.;
  users = [ "me" ];
  setup = {
    gui = {
      enable = true;
      full = true;
      driver = {
        nvidia = true;
      };
      tool = {
        unity = true;
        handbrake = true;
        vlc = true;
      };
      misc = {
        steam-run = true;
      };
    };
    nogui = {
      audio = {
        enable = true;
      };
      network = {
        wifi = {
          home =  true;
        };
      };
    };
  };
}
