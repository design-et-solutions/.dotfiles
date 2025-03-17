{ mkNixosConfiguration, ... }:

mkNixosConfiguration {
  name = "test";
  system = "x86_64-linux";
  users = [ "me" ];
  hostConfig = {
    gui.enable = true;
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
