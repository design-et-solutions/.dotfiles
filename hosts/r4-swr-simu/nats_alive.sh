#!/usr/bin/env bash

NATS_URL="nats://192.100.1.1:32000"

if nats server check connection --server "$NATS_URL" &>/dev/null; then
    echo "✅ NATS server is up"
else
    echo "❌ NATS server is down or unreachable"
    exit 1
fi
