{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.bitcoin
  ];

  shellHook = ''
    echo "Bitcoin Core is available."
    echo "Use 'bitcoind' to manage the daemon."
    
    export BITCOIN_DATA_DIR="/tmp/bitcoin-regtest"
    mkdir -p "$BITCOIN_DATA_DIR"

    if ! pgrep -x "bitcoind" > /dev/null; then
      bitcoind -regtest -datadir="$BITCOIN_DATA_DIR" -daemon
      echo "Bitcoin regtest node started with data directory $BITCOIN_DATA_DIR."
    else
      echo "Bitcoin regtest node is already running."
    fi

    echo "To stop the node, use 'bitcoin-cli -regtest -datadir=$BITCOIN_DATA_DIR stop'."
  '';

  shellExit = ''
    echo "Shutting down the Bitcoin regtest node..."
    bitcoin-cli -regtest -datadir=$BITCOIN_DATA_DIR stop || true
  '';
}
