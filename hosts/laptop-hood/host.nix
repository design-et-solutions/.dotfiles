# hosts/desktop-hood.nix
{ mkNixosConfiguration, ... }:
mkNixosConfiguration {
  system = "x86_64-linux";
  host = ./.;
  users = [ "me" ];
  setup = {
    gui = {
      enable = true;
      nvidia = true;
      unity = false;
      steam = false;
      steam-run = true;
      solaar = true;
      streamio = false;
      handbrake = true;
      vlc = true;
    };
    audio = {
      enable = true;
      spotify = true;
    };
    network = {
      wifi = {
        home =  true;
      };
      bluetooth = true;
      can = {
        enable = true;
        peak = true;
      };
    };
  };
}

