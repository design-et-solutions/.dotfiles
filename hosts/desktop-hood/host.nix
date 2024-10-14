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
      nvidia = true;
      unity = true;
      steam = true;
      steam-run = true;
      solaar = true;
      streamio = true;
      via = true;
      handbrake = true;
      vlc = true;
      discord = true;
      obs = true;
    };
    audio = {
      enable = true;
      spotify = true;
    };
    network = {
      wifi = {
        home =  true;
      };
    };
  };
}
