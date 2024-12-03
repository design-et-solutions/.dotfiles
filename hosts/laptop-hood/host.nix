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
        mail = true;
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
        vpn = {
          client = true;
          is_external = true;
        };
        wifi = {
          emergency = true;
        };
        bluetooth = true;
        # can = {
          # enable = true;
          # peak = true;
        # };
      };
      driver = {
        printer = true;
      };
    };
  };
}

