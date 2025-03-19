{ mkNixosConfiguration, ... }:

mkNixosConfiguration {
  name = "r4-swr-trunk";
  system = "x86_64-linux";
  users = [ "me" ];
  hostConfig = {
    gui = {
      enable = true;
      params = {
        displayServer = {
          wayland = false;
          x11 = true;
        };
        windowManager = {
          hyprland = false;
          i3 = true;
        };
      };
    };
    nogui = false;
    vm.docker.enable = true;
    browser.firefox.enable = true;
  };
}
