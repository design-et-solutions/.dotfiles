{ mkNixosConfiguration, ... }:
mkNixosConfiguration {
  system = "aarch64-linux";
  users = [ "bodyguard" ];
  hostConfig = {
    nogui = {
      network = {
        wireshark = true;
        vpn.server = true;
        wifi.emergency = true;
        suricata = true;
      };
      security = {
        blocky = true;
        nikto = true;
      };
    };
    controller.rpi5 = true;
  };
}
