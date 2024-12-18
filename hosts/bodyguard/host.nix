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
        suricata = true;
      };
      security = {
        blocky = true;
        nikto = true;
        lynis = true;
      };
    };
    controller.rpi5 = true;
  };
}
