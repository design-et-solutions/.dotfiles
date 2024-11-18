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
      driver = {
        nvidia = true;
      };
      comm = {
        discord = true;
        slack = true;
        teams = true;
        whatsapp = true;
      };
      tool = {
        solaar = true;
        handbrake = true;
        vlc = true;
        gimp = true;
        vial = true;
        drawio = true;
      };
      misc = {
        steam-run = true;
      };
    };
    nogui = {
      audio = {
        enable = true;
        spotify = true;
      };
      network = {
        mail = true;
        wifi = {
          home =  true;
          emergency = true;
        };
        bluetooth = true;
        can = {
          enable = true;
          peak = true;
        };
      };
      driver = {
        printer = true;
      };
    };
  };
}

