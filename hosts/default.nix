{ mkNixosConfiguration, ... }:
{
  desktop-hood = mkNixosConfiguration {
    system = "x86_64-linux";
    host = ./desktop_hood;
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
      ../projects/fatherhood
    ];
  };
  desktop-4644 = mkNixosConfiguration {
    system = "x86_64-linux";
    host = ./desktop_4644;
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
      ../projects/fatherhood
      ../projects/cantrolly
      ../projects/sniffy
      ../../4644-ZDZ110/soft-high-level/nix/os.nix
    ];
  };
  laptop-hood = mkNixosConfiguration {
    system = "x86_64-linux";
    host = ./laptop_hood;
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
      ../projects/fatherhood
    ];
  };
}
