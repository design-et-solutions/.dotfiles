{ mkNixosConfiguration, ... }:

mkNixosConfiguration {
  name = "test";
  system = "x86_64-linux";
  users = [ "me" ];
  hostConfig = { };
}
