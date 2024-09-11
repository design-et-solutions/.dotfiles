
# hosts/desktop-hood.nix
{ mkNixosConfiguration, nixos-hardware, ... }:

mkNixosConfiguration {
  system = "x86_64-linux";
  host = ./.;
  users = [ "guest" ];
  setup = {
    gui = {
      enable = true;
      nvidia = true;
    };
    audio = {
      enable = true;
    };
    network = {
      wifi = {
        home =  false;
      };
      can = {
        enable = true;
        peak = true;
      };
    };
  };
  extraModules = [
    "/home/me/4644-ZDZ110/soft-high-level/nix/os.nix"
  ];
};
