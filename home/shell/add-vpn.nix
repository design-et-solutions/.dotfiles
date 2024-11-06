{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    networkmanager
  ];

  shellHook = ''
    start() {
      sudo nmcli connection add type vpn vpn-type pptp con-name "$1" ifname "*" \
      -- \
      vpn.data "gateway=$2,user=$3" \
      vpn.secrets "password=$4"

      sudo nmcli connection modify "$1" ipv4.never-default yes

      sudo nmcli connection up "$1"

      sudo nmcli connection show --active
    }
  '';
}
