{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.bitcoin
  ];

  shellHook = ''
    echo "Bitcoin Core is available."
    echo "Use 'bitcoind' to manage the daemon."
    
    mkdir -p /tmp/bitcoin-regtest
    bitcoind -regtest -datadir=/tmp/bitcoin-regtest -daemon
    echo "Bitcoin regtest node started with data directory /tmp/bitcoin-regtest."
  '';
}
