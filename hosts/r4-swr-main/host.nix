{ mkNixosConfiguration, ... }:

mkNixosConfiguration {
  system = "x86_64-linux";
  host = ./.;
  users = [
    "me"
    "guest"
  ];
  setup = {
    gui.enable = true;
    gpu.enable = true;
    browser.enable = true;
    file_explorer.enable = true;
    vm.enable = true;
    networking = {
      analyzer.enable = true;
      wifi.emergency = true;
    };
    security = {
      blocker.enable = true;
      analyzer.enable = true;
    };
  };
}
