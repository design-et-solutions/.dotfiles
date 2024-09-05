{ mkNixosConfiguration }:
{
  desktop-hood = mkNixosConfiguration {
    system = "x86_64-linux";
    hostModule = ./desktop/hood;
    isGui = true;
    users = [ "me" ];
  };
  laptop-hood = mkNixosConfiguration {
    system = "x86_64-linux";
    hostModule = ./laptop/hood;
    isGui = true;
    users = [ "me" ];
  };
}
