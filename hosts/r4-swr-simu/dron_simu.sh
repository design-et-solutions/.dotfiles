#!/bin/bash

THRESHOLD=10
NO_MOVE_COUNT=0

get_state() {
    tlm-data-logger inet:127.0.0.1:9060 | \
      grep -E 'relativeLinearVelocity|worldPosition' | \
      grep -m6 -E 'x:|y:|z:' | \
      awk '{print $2}' | tr '\n' ' ' | md5sum | awk '{print $1}'
}

LAST_STATE=$(get_state)

while true; do
    sleep 1
    CURRENT_STATE=$(get_state)
    if [[ "$CURRENT_STATE" == "$LAST_STATE" ]]; then
        ((NO_MOVE_COUNT++))
        echo "No movement detected: $NO_MOVE_COUNT seconds"
        if (( NO_MOVE_COUNT >= THRESHOLD )); then
            echo "Drone appears stuck! Restarting drone..."
            sphinx-cli reset
            NO_MOVE_COUNT=0
        fi
    else
        echo "Mouvement detected: $CURRENT_STATE"
        NO_MOVE_COUNT=0
        LAST_STATE="$CURRENT_STATE"
    fi
done
