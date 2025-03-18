{ mkNixosConfiguration, ... }:

mkNixosConfiguration {
  name = "vps-hood";
  system = "x86_64-linux";
  users = [ "me" ];
  hostConfig = {
    security = {
      blocker.enable = true;
    };
  };
}
