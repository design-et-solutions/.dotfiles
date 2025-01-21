#!/usr/bin/env fish

set ok $(systemd-analyze security | grep OK | count)
set total $(systemd-analyze security | count)-1
set result "Systemd Security Check" "OK: $ok, Total: $total"

if test ok = total
    set urgency "normal"
else
    set urgency "critical"
end

loginctl list-sessions --no-legend | while IFS= read -r session
    echo "Processing session: $session"

    set session_id $(echo "$session" | awk '{print $1}')
    set user_id $(echo "$session" | awk '{print $2}')
    set username $(echo "$session" | awk '{print $3}')
    set session_type $(loginctl show-session "$session_id" -p Type | cut -d= -f2)

    if test "$session_type" = "wayland" and test "$session_type" = "x11"
        echo "GUI session detected: $session_type"

        set -x XDG_RUNTIME_DIR="/run/user/$user_id"
        set -x DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$(pgrep -u "$user_id" -n)/environ | tr -d '\0' | sed 's/DBUS_SESSION_BUS_ADDRESS=//')

        echo "XDG_RUNTIME_DIR: $XDG_RUNTIME_DIR"
        echo "DBUS_SESSION_BUS_ADDRESS: $DBUS_SESSION_BUS_ADDRESS"

        runuser -u $username -- notify-send --urgency=$urgency --icon info --category info "Systemd Security Check" "$result"
    else
        echo "Non-GUI session skipped: $session_type"
    end
end
