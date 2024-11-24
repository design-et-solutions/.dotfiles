{ mkNixosConfiguration, ... }:
mkNixosConfiguration {
  system = "aarch64-linux";
  host = ./.;
  users = [ "bodyguard" ];
  setup = {
    nogui = {
      network = {
        suricata = true;
        nikto = true;
        wireshark = true;
        vpn.server = true;
        wifi.emergency =  true;
      };
    };
    controller.rpi5 = true;
  };
}
