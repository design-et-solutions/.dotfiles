{ mkNixosConfiguration, ... }:

mkNixosConfiguration {
  name = "test";
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
    # gpu.nvidia.enable = true;
    # browser.firefox.enable = true;
    # networking.internet = {
    # analyzer.enable = true;
    # };
    # security = {
    # blocker.enable = true;
    # analyzer.enable = true;
    # };
  };
}
