# hosts/desktop-hood.nix
{ mkNixosConfiguration, nixos-hardware, ... }:

mkNixosConfiguration {
  system = "aarch64-linux";
  host = ./.;
  users = [ "me" ];
  setup = {
    gui = {
      enable = true;
      full = false;
    };
    nogui.networkwifi.emergency =  true;
    controller.rpi5 = true;
  };
}
