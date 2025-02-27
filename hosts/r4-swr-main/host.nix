{ mkNixosConfiguration, ... }:

mkNixosConfiguration {
  system = "x86_64-linux";
  host = ./.;
  users = [
    "me"
  ];
  setup = {
    gui.enable = true;
    gpu.enable = true;
    browser.enable = true;
    file_explorer.enable = true;
    vm.enable = true;
    networking = {
      analyzer.enable = true;
      wifi.emergency.enable = true;
      allowedPorts.tcp = [
        3000 # Server
        3001 # React
        9999 # WebRTC
        8554 # RTSP
      ];
    };
    security = {
      blocker.enable = true;
      analyzer.enable = true;
    };
    autoLogin = {
      enable = true;
      user = "me";
    };
  };
}
