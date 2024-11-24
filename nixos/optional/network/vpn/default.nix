{ ... }:
{
  networking= {
    firewall = {
      allowedUDPPorts = [ 51820 ];
    };
    wireguard = {
      enable = true;
      interfaces = {
        wg0 = {
          listenPort = 51820;
          # sudo mkdir -p /etc/wireguard
          # sudo bash -c "wg genkey > /etc/wireguard/private.key" 
          # sudo chmod 600 /etc/wireguard/private.key 
          privateKeyFile = "/etc/wireguard/private.key";
        };
      };
    };
  };
}
