{ mkNixosConfiguration, ... }:
mkNixosConfiguration {
  system = "aarch64-linux";
  host = ./.;
  users = [ "me" ];
  setup = {
    nogui = {
      network = {
        vpn.client = true;
        wifi.emergency =  true;
      };
    };
    controller.rpi5 = true;
  };
}
