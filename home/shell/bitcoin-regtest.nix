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
        
        echo "[regtest]" > "$BITCOIN_DATA_DIR/bitcoin.conf"
        echo "rpcuser=$RPC_USER" >> "$BITCOIN_DATA_DIR/bitcoin.conf"
        echo "rpcpassword=$RPC_PASSWORD" >> "$BITCOIN_DATA_DIR/bitcoin.conf"
        echo "rpcport=$RPC_PORT" >> "$BITCOIN_DATA_DIR/bitcoin.conf"

        if ! pgrep -x "bitcoind" > /dev/null; then
            bitcoind -regtest -datadir="$BITCOIN_DATA_DIR" -daemon 
            echo "Bitcoin regtest node started with data directory $BITCOIN_DATA_DIR."
        else
            echo "Bitcoin regtest node is already running."
        fi

        echo ""
        echo "-----FUNCTIONS------"
        echo 1 . network_info
        echo 2 . new_address
        echo 3 . generate_blocks
        echo 4 . wallet_balance
        echo 5 . send_coins
        echo 6 . utxos
        echo 7 . transaction_info
        echo 8 . create_wallet
        echo 9 . all_wallets
        echo 10. load_wallet
        echo "--------------------"

        network_info() {
            echo "ensure your Bitcoin node is running and accessible"
            bitcoin-cli -regtest -datadir="$BITCOIN_DATA_DIR" getblockchaininfo
        }

        new_address() {
            echo "generate a new Bitcoin address to receive coins"
            bitcoin-cli -regtest -datadir="$BITCOIN_DATA_DIR" getnewaddress
        }
        
        generate_blocks() {
            echo "generate 101 blocks and reward coins to a new address for $WALLET"
            echo "the reason for generating 101 blocks is to bypass the 100-block maturity period so you can immediately spend the coins."
            address=$(bitcoin-cli -regtest -datadir="$BITCOIN_DATA_DIR" -rpcwallet=$WALLET getnewaddress)
            bitcoin-cli -regtest -datadir="$BITCOIN_DATA_DIR" -rpcwallet=$WALLET generatetoaddress 101 "$address"
        }

        wallet_balance() {
            echo "see the balance of your wallet"
            bitcoin-cli -regtest -datadir="$BITCOIN_DATA_DIR" getbalance
        }

        send_coins() {
            echo "send coins ($2) to $1"
            bitcoin-cli -regtest -datadir="$BITCOIN_DATA_DIR" sendtoaddress "$1" $2
        }

        utxos() {
            echo "check for unspent transaction outputs (UTXOs) in your wallet"
            bitcoin-cli -regtest -datadir="$BITCOIN_DATA_DIR" listunspent
        }

        transaction_info() {
            echo "transaction $1 information"
            bitcoin-cli -regtest -datadir="$BITCOIN_DATA_DIR" gettransaction "$1"
        }

        create_wallet() {
            echo "create a new wallet $1"
            bitcoin-cli -regtest -datadir="$BITCOIN_DATA_DIR" createwallet "$1"
            echo "load wallet $1"
            bitcoin-cli -regtest -datadir="$BITCOIN_DATA_DIR" loadwallet "$1"
        }

        all_wallets() {
            echo "see all wallets available in the wallet directory"
            bitcoin-cli -regtest -datadir="$BITCOIN_DATA_DIR" listwalletdir
        }

        load_wallet() {
            echo "loading wallet $1"
            bitcoin-cli -regtest -datadir="$BITCOIN_DATA_DIR" loadwallet "$1"
        }

        cleanup() {
            echo "Shutting down the Bitcoin regtest node..."
            bitcoin-cli -regtest -datadir=$BITCOIN_DATA_DIR stop || true
        }

        trap cleanup EXIT
    '';
}
