{ mkNixosConfiguration, ... }:
{
  desktop-hood = mkNixosConfiguration {
    system = "x86_64-linux";
    host = ./desktop/hood;
    users = [ "me" ];
    setup = {
      gui = {
        enable = true;
        nvidia = true;
        unity = true;
        steam = true;
        steam-run = true;
        solaar = true;
        pavucontrol = true;
        streamio = true;
        vial = true;
        handbrake = true;
        vlc = true;
      };
      audio = {
        enable = true;
        spotify = true;
      };
      network = {
        wifi = {
          home =  true;
        };
        bluetooth = false;
        can = {
          enable = false;
          peak = false;
        };
      };
    };
    extraModules = [
      "/home/me/Fatherhood/nix/os.nix"
    ];
  };
  zdz110 = mkNixosConfiguration {
    system = "x86_64-linux";
    host = ./../../work/4644-ZDZ110/soft-high-level/nix/host.nix;
    users = [ "guest" ];
    setup = {
      gui = {
        enable = true;
        nvidia = true;
        unity = false;
        steam = false;
        steam-run = false;
        solaar = false;
        pavucontrol = false;
        streamio = false;
        vial = false;
        handbrake = false;
        vlc = false;
      };
      audio = {
        enable = true;
        spotify = false;
      };
      network = {
        wifi = {
          home =  false;
        };
        bluetooth = false;
        can = {
          enable = true;
          peak = true;
        };
      };
    };
    extraModules = [
      "/home/me/Fatherhood/nix/os.nix"
      "/home/me/work/4644-ZDZ110/soft-high-level/nix/os.nix"
    ];
  };
  laptop-hood = mkNixosConfiguration {
    system = "x86_64-linux";
    host = ./laptop/hood;
    users = [ "me" ];
    setup = {
      gui = {
        enable = true;
        nvidia = true;
        unity = false;
        steam = false;
        steam-run = true;
        solaar = true;
        streamio = false;
        pavucontrol = true;
        vial = false;
        handbrake = true;
        vlc = true;
      };
      audio = {
        enable = true;
        spotify = true;
      };
      python = true;
      network = {
        wifi = {
          home =  true;
        };
        bluetooth = true;
        can = {
          enable = true;
          peak = true;
        };
      };
    };
    extraModules = [
      "/home/me/Fatherhood/nix/os.nix"
    ];
  };
}
