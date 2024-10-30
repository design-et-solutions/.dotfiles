{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
    buildInputs = [
        pkgs.bitcoin
        pkgs.jq
    ];

    shellHook = ''
        echo "Bitcoin Core is available."
        echo "Use 'bitcoind' to manage the daemon."
        
        BITCOIN_DATA_DIR="/tmp/bitcoin-regtest"
        mkdir -p "$BITCOIN_DATA_DIR"

        RPC_USER="user"
        RPC_PASSWORD="password"
        RPC_PORT="18443"

        WALLET=1
        
        echo "[regtest]" > "$BITCOIN_DATA_DIR/bitcoin.conf"
        echo "fallbackfee=0.0001" >> "$BITCOIN_DATA_DIR/bitcoin.conf"
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
        echo 0 . init_wallet
        echo 1 . network_info
        echo 2 . new_address
        echo 3 . generate_blocks
        echo 4 . wallet_balance
        echo 5 . send_coins address amount
        echo 6 . utxos address
        echo 7 . transaction_info txid
        echo 8 . create_wallet wallet_name
        echo 9 . all_wallets 
        echo 10. load_wallet wallet_name
        echo 11. create_wallet_watch_only wallet_name
        echo 12. external_utxos recipient_address
        echo "--------------------"

        init_wallet() {
            echo "initialize wallet"
            bitcoin-cli -regtest -datadir="$BITCOIN_DATA_DIR" createwallet "main"
            bitcoin-cli -regtest -datadir="$BITCOIN_DATA_DIR" createwallet "watchonly" true true
            bitcoin-cli -regtest -datadir="$BITCOIN_DATA_DIR" loadwallet "main"
            bitcoin-cli -regtest -datadir="$BITCOIN_DATA_DIR" loadwallet "watchonly"
        }

        network_info() {
            echo "ensure your Bitcoin node is running and accessible"
            bitcoin-cli -regtest -datadir="$BITCOIN_DATA_DIR" getblockchaininfo
        }

        new_address() {
            echo "generate a new Bitcoin address to receive coins"
            bitcoin-cli -regtest -datadir="$BITCOIN_DATA_DIR" getnewaddress
        }
        
        generate_blocks() {
            if [ -z "$1" ]; then
                echo "Error: No wallet provided."
                return 1
            fi
            echo "generate 101 blocks and reward coins to a new address for $1"
            echo "the reason for generating 101 blocks is to bypass the 100-block maturity period so you can immediately spend the coins."
            address=$(bitcoin-cli -regtest -datadir="$BITCOIN_DATA_DIR" -rpcwallet=$1 getnewaddress)
            bitcoin-cli -regtest -datadir="$BITCOIN_DATA_DIR" -rpcwallet=$1 generatetoaddress 101 "$address"
        }

        wallet_balance() {
            if [ -z "$1" ]; then
                echo "Error: No wallet provided."
                return 1
            fi
            echo "see the balance of your wallet $1"
            bitcoin-cli -regtest -datadir="$BITCOIN_DATA_DIR" -rpcwallet=$1 getbalance
        }

        send_coins() {
            if [ -z "$1" ]; then
                echo "Error: No wallet provided."
                return 1
            fi
            if [ -z "$2" ]; then
                echo "Error: No address provided."
                return 1
            fi
            if [ -z "$3" ]; then
                echo "Error: No amount provided."
                return 1
            fi
            echo "send coins ($3) to $2"
            bitcoin-cli -regtest -datadir="$BITCOIN_DATA_DIR" -rpcwallet="$1" sendtoaddress "$2" $3
        }

        utxos() {
            echo "check for unspent transaction outputs (UTXOs) in your wallet"
            bitcoin-cli -regtest -datadir="$BITCOIN_DATA_DIR" listunspent
        }

        transaction_info() {
            if [ -z "$1" ]; then
                echo "Error: No txid provided."
                return 1
            fi
            echo "transaction $1 information"
            bitcoin-cli -regtest -datadir="$BITCOIN_DATA_DIR" gettransaction "$1"
        }

        create_wallet() {
            if [ -z "$1" ]; then
                echo "Error: No wallet provided."
                return 1
            fi
            echo "create a new wallet $1"
            bitcoin-cli -regtest -datadir="$BITCOIN_DATA_DIR" createwallet "$1"
        }

        create_wallet_watch_only() {
            if [ -z "$1" ]; then
                echo "Error: No wallet provided."
                return 1
            fi
            echo "create a new wallet $1"
            bitcoin-cli -regtest -datadir="$BITCOIN_DATA_DIR" createwallet "$1" true true
        }

        all_wallets() {
            echo "see all wallets available in the wallet directory"
            bitcoin-cli -regtest -datadir="$BITCOIN_DATA_DIR" listwalletdir
        }

        load_wallet() {
            if [ -z "$1" ]; then
                echo "Error: No wallet provided."
                return 1
            fi
            echo "loading wallet $1"
            bitcoin-cli -regtest -datadir="$BITCOIN_DATA_DIR" loadwallet "$1"
        }

        external_utxos() {
            if [ -z "$2" ]; then
                echo "Error: No wallet provided."
                return 1
            fi
            if [ -z "$1" ]; then
                echo "Error: No address provided."
                return 1
            fi
            DESCRIPTOR_INFO=$(bitcoin-cli -regtest -datadir="$BITCOIN_DATA_DIR" getdescriptorinfo "addr($2)")
            CHECKSUM=$(echo "$DESCRIPTOR_INFO" | jq -r '.checksum')
            DESCRIPTOR="addr($2)#$CHECKSUM"

            IMPORT_RESULT=$(bitcoin-cli -regtest -datadir="$BITCOIN_DATA_DIR" -rpcwallet="$1" importdescriptors \
                "[{ \"desc\": \"$DESCRIPTOR\", \"label\": \"automated_import\", \"timestamp\": \"now\" }]")

            if echo "$IMPORT_RESULT" | grep -q '"success": false'; then
                echo "Failed to import descriptor for address $2."
                return 1
            fi

            UTXO_RESULT=$(bitcoin-cli -regtest -datadir="$BITCOIN_DATA_DIR" scantxoutset start "[{ \"desc\": \"$DESCRIPTOR\" }]")

            # Parse and display UTXOs
            echo "UTXOs for address $1:"
            echo "$UTXO_RESULT" | jq -r '.unspents[] | "TXID: \(.txid), VOUT: \(.vout), Amount: \(.amount), Height: \(.height)"'
        }

        cleanup() {
            echo "Shutting down the Bitcoin regtest node..."
            bitcoin-cli -regtest -datadir=$BITCOIN_DATA_DIR stop || true
        }

        trap cleanup EXIT
    '';
}
