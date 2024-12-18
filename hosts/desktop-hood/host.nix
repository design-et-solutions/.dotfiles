{ mkNixosConfiguration, ... }:

mkNixosConfiguration {
  system = "x86_64-linux";
  host = ./.;
  users = [ "me" ];
  setup = {
    gui = {
      enable = true;
      full = true;
      driver.nvidia = true;
      comm = {
        mail = true;
        discord = true;
        slack = true;
        teams = true;
        whatsapp = true;
      };
      tool = {
        unity = true;
        vial = true;
        handbrake = true;
        vlc = true;
        drawio = true;
      };
      misc = {
        steam = true;
        steam-run = true;
        mgba = true;
        streamio = true;
      };
    };
    nogui = {
      audio = {
        enable = true;
        spotify = true;
      };
      tool = {
        solaar = true;
        appimage = true;
      };
      network = {
        vpn.client = true;
        wifi.emergency =  true;
      };
      driver.printer = true;
      misc.xbox_controller = true;
    };
  };
}
