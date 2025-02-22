{ mkNixosConfiguration, ... }:

mkNixosConfiguration {
  system = "x86_64-linux";
  host = ./.;
  users = [ "me" ];
  setup = {
    autoLogin = {
      enable = true;
      user = "me";
    };
    gui.enable = true;
    gpu.enable = true;
    browser.enable = true;
    file_explorer.enable = true;
    mail.enable = true;
    print.enable = true;
    vm.enable = true;
    game = {
      steam.enable = true;
      mgba.enable = true;
      xbox_controller.enable = true;
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
      unity.enable = true;
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
      analyzer.enable = true;
      # vpn = {
      #   default.enable = true;
      #   client.enable = true;
      # };
    };
    security = {
      blocker.enable = true;
      analyzer.enable = true;
    };
  };
}
