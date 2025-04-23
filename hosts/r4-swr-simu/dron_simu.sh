#!/bin/bash

export LC_NUMERIC=C

TLM_PORT="inet:127.0.0.1:9060"
MAX_IDLE=10

# Declare associative arrays for state tracking
declare -A last_value
declare -A idle_counter

# Metrics to monitor
declare -A metrics=(
  ["omniscient_anafi_ai.lastCollisionTime"]="collision"
  ["actuator_anafi_ai.rr_motorSpeed"]="motor"
  ["actuator_anafi_ai.fl_worldPosition.z"]="altitude"
  ["smart_battery_anafi_ai.battery_capacity"]="battery"
  ["actuator_anafi_ai.fr_worldAttitude.x"]="attitude_x"
  ["actuator_anafi_ai.fr_worldAttitude.y"]="attitude_y"
)

restart_drone() {
  echo "Drone is stuck. Restarting Sphinx..."
  sphinx-cli action -m world fwman world_reset_all
  sleep 20
}

reset_state() {
  for l in "${!idle_counter[@]}"; do idle_counter[$l]=0; done
  for l in "${!last_value[@]}"; do last_value[$l]=""; done
}

process_metric() {
  local key="$1"
  local label="$2"
  local value="$3"

  # Validate numeric value
  if ! [[ "$value" =~ ^-?[0-9]+([.][0-9]+)?$ ]]; then
    echo "Invalid numeric value ($label): $value"
    return
  fi

  if [[ "$label" == "altitude" ]]; then
    awk -v val="$value" 'BEGIN { exit (val<0.5)?0:1 }'
    if [[ $? -eq 0 ]]; then
      echo "Altitude crash detected: $value m < 0.5 m"
      return 2
    fi
  fi

  if [[ "$label" == "battery" ]]; then
    awk -v val="$value" 'BEGIN { exit (val<15)?0:1 }'
    if [[ $? -eq 0 ]]; then
      echo "Battery low: $value% < 15%"
      return 2
    fi
  fi

  if [[ "$label" == "attitude_x" || "$label" == "attitude_y" ]]; then
    awk -v val="$value" 'BEGIN { exit (val > 1.0 || val < -1.0)?0:1 }'
    if [[ $? -eq 0 ]]; then
      echo "Attitude anomaly on $label axis: $value rad"
      return 2
    fi
  fi

  if [[ -z "${last_value[$label]}" ]]; then
    last_value[$label]="$value"
    echo "Initial value set ($label): $value"
    return 0
  fi

  if [[ "$value" == "${last_value[$label]}" ]]; then
    idle_counter[$label]=$((idle_counter[$label]+1))
    echo "Drone is stuck ($label): $value (${idle_counter[$label]} s)"
  else
    idle_counter[$label]=0
    echo "Drone isn't stuck ($label): $value != ${last_value[$label]}"
  fi

  last_value[$label]="$value"
  return 0
}

main_loop() {
  while read -r line; do
    for pattern in "${!metrics[@]}"; do
      if [[ "$line" =~ $pattern ]]; then
        value=$(echo "$line" | awk '{print $2}')
        process_metric "$pattern" "${metrics[$pattern]}" "$value"
        code=$?
        if [[ $code -eq 2 ]]; then
          return 2
        fi
      fi
    done

    if [[ "${idle_counter[collision]:-0}" -ge "$MAX_IDLE" && "${idle_counter[motor]:-0}" -ge "$MAX_IDLE" ]]; then
      return 1
    fi
  done < <(tlm-data-logger "$TLM_PORT")
}

while true; do
  main_loop
  code=$?
  if [[ $code -eq 1 ]]; then
    restart_drone
    reset_state
  elif [[ $code -eq 2 ]]; then
    restart_drone
    reset_state
  else
    echo "tlm-data-logger exited unexpectedly. Restarting..."
    sleep 2
  fi
done
