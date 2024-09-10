# hosts/desktop-hood.nix
{ mkNixosConfiguration, nixos-hardware, ... }:

mkNixosConfiguration {
  system = "x86_64-linux";
  host = ./.;
  users = [ "me" "guest" ];
  setup = {
    gui = {
      enable = true;
      nvidia = true;
      unity = false;
      steam = false;
      steam-run = true;
      solaar = false;
      streamio = false;
      vial = false;
      handbrake = true;
      vlc = false;
    };
    audio = {
      enable = false;
      spotify = false;
    };
    network = {
      wifi = {
        home =  false;
        emergency =  false;
      };
      bluetooth = false;
      can = {
        enable = true;
        peak = true;
      };
    };
    misc = {
      docker = false;
    };
  };
  extraModules = [
    "/home/guest/4651-UGREEN/soft-high-level/nix/os.nix"
  ];
}
