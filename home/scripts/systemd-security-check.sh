#!/usr/bin/env bash

# Service to monitor
SERVICE_NAME="systemd-security-check"

# Get the latest log entry from the systemd service
result=$(journalctl -u "$SERVICE_NAME" -n 1 --no-pager --quiet | tail -n 1)

ok=$(echo "$result" | awk '{print $2}')
total=$(echo "$result" | awk '{print $5}')

echo $ok
echo $total

if [ "$ok" -eq "$total" ]; then
  urgency="normal"
else
  urgency="critical"
fi

# Send notification
notify-send --urgency=$urgency --category info "Systemd Security Check" "$result"
