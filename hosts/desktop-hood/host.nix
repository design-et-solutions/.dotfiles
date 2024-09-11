# hosts/desktop-hood.nix
{ mkNixosConfiguration, nixos-hardware, ... }:

mkNixosConfiguration {
  system = "x86_64-linux";
  host = ./.;
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
      can = {
        enable = true;
        peak = true;
      };
    };
  };
}
