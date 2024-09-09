# hosts/desktop-hood.nix
{ mkNixosConfiguration, ... }:

mkNixosConfiguration {
  system = "x86_64-linux";
  host = ./desktop_hood;
  users = [ "guest" ];
  setup = {
    gui = {
      enable = true;
      nvidia = false;
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
      enable = false;
      spotify = false;
    };
    network = {
      wifi = {
        home =  false;
        emergency =  true;
      };
      bluetooth = false;
      can = {
        enable = true;
        peak = true;
      };
    };
  };
  extraModules = [
    ({ config, ... }: {
      imports = [ ../projects/fatherhood ];
      services.fatherhood = {
        enable = false;
      };
    })
    "../../../4658-UGreen/soft-high-level/nix/os.nix"
  ];
}
