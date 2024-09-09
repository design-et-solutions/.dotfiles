# hosts/desktop-hood.nix
{ mkNixosConfiguration, nixos-hardware, ... }:

mkNixosConfiguration {
  system = "aarch64-linux";
  host = ./.;
  users = [ "root" "guest" ];
  setup = {
    gui = {
      enable = true;
      nvidia = false;
      unity = false;
      steam = false;
      steam-run = false;
      solaar = false;
      streamio = false;
      vial = false;
      handbrake = false;
      vlc = false;
    };
    audio = {
      enable = false;
      spotify = false;
    };
    network = {
      wifi = {
        home =  false;
        emergency =  true;
      };
      bluetooth = false;
      can = {
        enable = true;
        peak = true;
      };
    };
    misc = {
      podman = false;
    };
  };
  extraModules = [
    nixos-hardware.nixosModules.raspberry-pi-4
    ({ config, ... }: {
      imports = [ ../../projects/fatherhood ];
      services.fatherhood = {
        enable = false;
      };
    })
    "/home/nixos/4658-UGreen/soft-high-level/nix/os.nix"
  ];
}