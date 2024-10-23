# hosts/desktop-hood.nix
{ mkNixosConfiguration, ... }:
mkNixosConfiguration {
  system = "x86_64-linux";
  host = ./.;
  users = [ "me" ];
  setup = {
    gui = {
      enable = true;
      full = true;
      nvidia = true;
      unity = false;
      steam = false;
      steam-run = true;
      solaar = true;
      streamio = false;
      handbrake = true;
      vlc = true;
      gimp = true;
      via = true;
      discord = true;
      slack = true;
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

