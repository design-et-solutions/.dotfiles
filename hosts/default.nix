{ mkNixosConfiguration }:
{
  desktop-hood = mkNixosConfiguration {
    system = "x86_64-linux";
    hostModule = ./desktop/hood;
    extraModules = [ ./../nixos/optional/gui ];
    isGui = true;
    users = [ "me" ];
  };
  laptop-hood = mkNixosConfiguration {
    system = "x86_64-linux";
    hostModule = ./laptop/hood;
    extraModules = [ ./../nixos/optional/gui ];
    isGui = true;
    users = [ "me" ];
  };
  desktop-work-4651-master = mkNixosConfiguration {
    system = "x86_64-linux";
    hostModule = ./desktop/work/4651/master;
    extraModules = [ ./../nixos/optional/gui ];
    isGui = true;
    users = [ "guest" ];
  };
}
