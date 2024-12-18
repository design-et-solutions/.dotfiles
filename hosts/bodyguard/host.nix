{ mkNixosConfiguration, ... }:
mkNixosConfiguration {
  system = "aarch64-linux";
  host = ./.;
  users = [ "bodyguard" ];
  setup = {
    nogui = {
      network = {
        wireshark = true;
        vpn.server = true;
        wifi.emergency =  true;
      };
      security = {
        blocky = true;
        suricata = true;
        nikto = true;
      };
    };
    controller.rpi5 = true;
  };
}
