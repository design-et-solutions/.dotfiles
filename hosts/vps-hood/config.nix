{ mkNixosConfiguration, ... }:

mkNixosConfiguration {
  name = "vps-hood";
  system = "x86_64-linux";
  users = [ "me" ];
  hostConfig = {
    networking.internet = {
      analyzer.enable = true;
    };
    security = {
      blocker.enable = true;
      analyzer.enable = true;
    };
  };
}
