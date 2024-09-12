# hosts/desktop-hood.nix
{ mkNixosConfiguration, nixos-hardware, ... }:

mkNixosConfiguration {
  system = "x86_64-linux";
  host = ./.;
  users = [ "me" "guest" ];
  setup = {
    gui = {
      enable = true;
      extra.hyprland = ''
        cursor {
          inactive_timeout = 3
        }
      '';
      nvidia = true;
    };
    audio = {
      enable = true;
    };
    network = {
      wifi = {
        emergency =  true;
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
}
