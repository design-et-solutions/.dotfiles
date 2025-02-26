{ mkNixosConfiguration, ... }:

mkNixosConfiguration {
  system = "x86_64-linux";
  host = ./.;
  users = [
    "me"
    "guest"
  ];
  setup = {
    hyprland = {
      custom = ''
        monitor = eDP-1,2560x1440,auto,1
      '';
    };
    gui.enable = true;
    gpu.enable = true;
    browser.enable = true;
    file_explorer.enable = true;
    vm.enable = true;
    misc = {
      solaar.enable = true;
      handbrake.enable = true;
      gimp.enable = true;
      vial.enable = true;
      drawio.enable = true;
      steam-run.enable = true;
      stremio.enable = true;
      unity.enable = true;
    };
    video = {
      vlc.enable = true;
      mpv.enable = true;
    };
    audio = {
      default.enable = true;
    };
    networking = {
      analyzer.enable = true;
      wifi = {
        emergency.enable = true;
      };
    };
    security = {
      blocker.enable = true;
      analyzer.enable = true;
    };
  };
}
