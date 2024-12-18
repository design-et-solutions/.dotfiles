#!/usr/bin/env bash

# Command to analyze and count OK services
result=$(systemd-analyze security | awk '/OK/ {ok++} {total++} END {print "OK: " ok " / Total: " total}')

# Send notification
notify-send "Systemd Security Check" "$result"

