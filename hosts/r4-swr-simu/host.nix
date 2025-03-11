{ mkNixosConfiguration, ... }:

mkNixosConfiguration {
  system = "x86_64-linux";
  host = ./.;
  users = [
    "me"
    "guest"
  ];
  setup = {
    gui = {
      enable = true;
      params.autoLogin = {
        enable = true;
        user = "me";
      };
    };
    gpu.nvidia.enable = true;
    browser.firefox.enable = true;
    networking.internet = {
      analyzer.enable = true;
    };
    security = {
      blocker.enable = true;
      analyzer.enable = true;
    };
  };
}
