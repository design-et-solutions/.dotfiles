{ pkgs, mergedSetup, ... }:
{
  imports = [
    ./default.nix
  ];

  networking = {
    wg-quick =
      let
        peerPublicKey = "YTdToContsMCnJUr9yglcfd5T59YISBdRpRZ1w3IiH8=";
        privateKeyFilePath = "/etc/wireguard/wg0";
      in
      {
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
                allowedIPs = [
                  "0.0.0.0/0"
                  "::/0"
                ];
                endpoint =
                  if mergedSetup.networking.vpn.client.params.isExternal then
                    "128.78.107.5:51820"
                  else
                    "192.168.10.213:51820";
              }
            ];
          };
        };
      };
  };
}
