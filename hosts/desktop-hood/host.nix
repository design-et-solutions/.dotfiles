# hosts/desktop-hood.nix
{ mkNixosConfiguration, config, ... }:

mkNixosConfiguration {
  system = "x86_64-linux";
  host = ./desktop-hood;
  users = [ "me" ];
  setup = {
    gui = {
      enable = true;
      nvidia = true;
      unity = true;
      steam = true;
      steam-run = true;
      solaar = true;
      streamio = true;
      vial = true;
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
      bluetooth = false;
      can = {
        enable = false;
        peak = false;
      };
    };
  };
  extraModules = [
    ({ config, ... }: {
      imports = [ ../projects/fatherhood ];
      services.fatherhood = {
        enable = true;
        user = "1000";
      };
    })
  ];
}
