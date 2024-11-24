{ pkgs, ... }:
{
  networking= {
    wireguard = {
      interfaces = {
        wg0 = {
          peers = [
            {
              publicKey = "Jn1su3Fd9CPJHLhscEM8ecWMZ7abYfcu/DOhlNJBDVA=";
              # Forward all the traffic via VPN.
              allowedIPs = [ "0.0.0.0/0" "::/0" ];
              endpoint = "192.168.10.213:51820";
              persistentKeepalive = 25;
            }
          ];
        };
      };
    };
  };
}

