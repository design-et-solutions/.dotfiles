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

        RPC_USER="user"
        RPC_PASSWORD="password"
        RPC_PORT="18443"

        if ! pgrep -x "bitcoind" > /dev/null; then
            bitcoind -regtest -datadir="$BITCOIN_DATA_DIR" -daemon \
            -rpcuser=$RPC_USER -rpcpassword=$RPC_PASSWORD -rpcport=$RPC_PORT
            echo "Bitcoin regtest node started with data directory $BITCOIN_DATA_DIR."
        else
            echo "Bitcoin regtest node is already running."
        fi

        cleanup() {
            echo "Shutting down the Bitcoin regtest node..."
            bitcoin-cli -regtest -datadir=$BITCOIN_DATA_DIR stop || true
        }

        trap cleanup EXIT
    '';
}
