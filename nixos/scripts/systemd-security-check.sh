#!/usr/bin/env bash

# Initialize counters
ok=0
total=0

# Command to analyze and count OK services
result=$(systemd-analyze security | awk '/OK/ {ok++} {total++} END {print "OK: " ok " / Total: " total}')

# Extract ok and total from the result for comparison
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
