{ pkgs, is_external, ... }:
{
  imports = [
    ./default.nix
  ];

  networking= {
   wg-quick = let
      peerPublicKey = "Jn1su3Fd9CPJHLhscEM8ecWMZ7abYfcu/DOhlNJBDVA=";
      privateKeyFilePath = "/etc/wireguard/private.key";
    in {
      interfaces = {
        wg0 = {
          listenPort = 51820;
          privateKeyFile = privateKeyFilePath;
          postUp = ''
            wg set wg0 peer ${peerPublicKey} persistent-keepalive 25
          '';
          peers = [
            {
              publicKey = peerPublicKey;
              # Forward all the traffic via VPN.
              allowedIPs = [ "0.0.0.0/0" "::/0" ];
              endpoint = if is_external then "128.78.107.5:51820" else "192.168.10.213:51820";
            }
          ];
        };
      };
    };
  };
}
