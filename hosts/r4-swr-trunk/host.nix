{ mkNixosConfiguration, ... }:

mkNixosConfiguration {
  system = "x86_64-linux";
  host = ./.;
  users = [
    "me"
  ];
  setup = {
    gui = {
      enable = true;
      params = {
        autoLogin = {
          enable = true;
          user = "me";
        };
        displayServer = "x11";
      };
    };
    gpu.nvidia.enable = true;
    browser.firefox.enable = true;
    fileExplorer.enable = true;
    vm.docker.enable = true;
    networking.internet = {
      analyzer.enable = true;
      wifi.emergency.enable = true;
    };
    security = {
      blocker.enable = true;
      analyzer.enable = true;
    };
  };
}
