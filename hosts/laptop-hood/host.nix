{ mkNixosConfiguration, ... }:

mkNixosConfiguration {
  system = "x86_64-linux";
  host = ./.;
  users = [ "me" ];
  setup = {
    gui = {
      enable = true;
      params.hyprland = {
        custom = ''
          monitor = eDP-1,2560x1440,auto,1
        '';
      };
    };
    browser.firefox.enable = true;
    fileExplorer.enable = true;
    mail.enable = true;
    print.enable = true;
    vm.docker.enable = true;
    game = {
      steam.enable = true;
    };
    social = {
      discord.enable = true;
      slack.enable = true;
      teams.enable = true;
      whatsapp.enable = true;
    };
    misc = {
      solaar.enable = true;
      handbrake.enable = true;
      gimp.enable = true;
      vial.enable = true;
      drawio.enable = true;
      steam-run.enable = true;
      stremio.enable = true;
    };
    video = {
      vlc.enable = true;
      mpv.enable = true;
    };
    audio = {
      default.enable = true;
      spotify.enable = true;
    };
    networking = {
      internet = {
        analyzer.enable = true;
        # vpn = {
        #   default.enable = true;
        #   client.enable = true;
        #   isExternal = true;
        # };
        wifi = {
          emergency.enable = true;
        };
      };
      bluetooth.enable = true;
      # can = {
      #   default.enable = true;
      #   peak.enable = true;
      # };
    };
    security = {
      blocker.enable = true;
      analyzer.enable = true;
    };
  };
}
