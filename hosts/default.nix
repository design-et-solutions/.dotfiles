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
  # work
  desktop-work-4651-master = mkNixosConfiguration {
    system = "x86_64-linux";
    hostModule = ./desktop/work/4651/master;
    extraModules = [ ./../nixos/optional/gui ];
    isGui = true;
    users = [ "guest" ];
  };
  desktop-work-4644-master = mkNixosConfiguration {
    system = "x86_64-linux";
    hostModule = ./desktop/work/4644/master;
    extraModules = [ ./../nixos/optional/gui ];
    isGui = true;
    users = [ "guest" ];
  };
}
