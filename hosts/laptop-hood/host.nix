{ mkNixosConfiguration, ... }:

mkNixosConfiguration {
  name = "laptop-hood";
  system = "x86_64-linux";
  host = ./.;
  users = [ "me" ];
  setup = {
    disk.default = false;
    gui = {
      enable = true;
      params = {
        autoLogin = {
          enable = true;
          user = "me";
        };
        hyprland = {
          custom = ''
            monitor = eDP-1,2560x1440,auto,1
          '';
        };
      };
    };
    browser.firefox.enable = true;
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
      };
      bluetooth.enable = true;
    };
    security = {
      blocker.enable = true;
      analyzer.enable = true;
    };
  };
}
