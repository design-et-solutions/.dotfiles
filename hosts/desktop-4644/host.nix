
# hosts/desktop-hood.nix
{ mkNixosConfiguration, nixos-hardware, ... }:

mkNixosConfiguration {
  system = "x86_64-linux";
  host = ./.;
  users = [ "guest" ];
  setup = {
    gui = {
      enable = true;
      nvidia = true;
      unity = false;
      steam = false;
      steam-run = false;
      solaar = false;
      streamio = false;
      vial = false;
      handbrake = false;
      vlc = false;
    };
    audio = {
      enable = true;
      spotify = false;
    };
    network = {
      wifi = {
        home =  false;
      };
      bluetooth = false;
      can = {
        enable = true;
        peak = true;
      };
    };
  };
  extraModules = [
    "/home/me/4644-ZDZ110/soft-high-level/nix/os.nix"
  ];
};
