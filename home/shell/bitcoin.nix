{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.bitcoin
  ];

  shellHook = ''
    echo "Bitcoin Core is available. Use 'bitcoind' to start the daemon."
  '';
}
