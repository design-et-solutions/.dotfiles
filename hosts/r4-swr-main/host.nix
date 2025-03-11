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
      };
    };
    gpu.nvidia.enable = true;
    browser.firefox.enable = true;
    fileExplorer.enable = true;
    vm.docker.enable = true;
    networking = {
      internet = {
        analyzer.enable = true;
        wifi.emergency.enable = true;
      };
      params.allowedPorts.tcp = [
        3000 # Server
        9999 # WebRTC
        8554 # RTSP
      ];
    };
    security = {
      blocker.enable = true;
      analyzer.enable = true;
    };
  };
}
