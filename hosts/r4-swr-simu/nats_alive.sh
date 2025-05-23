#!/usr/bin/env bash

NATS_BIN="/home/me/go/bin/nats"
NATS_URL="nats://192.100.1.1:32000"

if $NATS_BIN server check connection --server "$NATS_URL" &>/dev/null; then
    echo "✅ NATS server is up"
else
    echo "❌ NATS server is down or unreachable"
    exit 1
fi
