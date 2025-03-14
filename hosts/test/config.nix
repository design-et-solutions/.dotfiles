{ mkNixosConfiguration, ... }:

mkNixosConfiguration {
  name = "test";
  system = "x86_64-linux";
  host = ./.;
  users = [ "me" ];
  setup = {
    networking.internet = {
      analyzer.enable = true;
    };
    security = {
      blocker.enable = true;
      analyzer.enable = true;
    };
  };
}
