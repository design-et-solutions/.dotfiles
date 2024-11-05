{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  buildInputs = [
    pkgs.network-manager-pptp
  ];

  shellHook = ''
    start() {
      nmcli connection add type vpn vpn-type pptp con-name "VPN_NAME" ifname "*" \
      -- \
      vpn.data "gateway=VPN_SERVER_ADDRESS,user=YOUR_USERNAME" \
      vpn.secrets "password=YOUR_PASSWORD"

      nmcli connection modify "VPN_NAME" ipv4.never-default yes

      nmcli connection up "YourVPN_NAME"

      nmcli connection show --active
    }
  '';
}
