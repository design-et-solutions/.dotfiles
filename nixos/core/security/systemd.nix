{ pkgs, ... }: {
  systemd.services.systemd-security-check = {
    description = "Run systemd security check";
    script = ''
      export PATH=${pkgs.coreutils}/bin:${pkgs.gawk}/bin:${pkgs.systemd}/bin:${pkgs.libnotify}/bin:${pkgs.procps}/bin:${pkgs.util-linux}/bin:$PATH

      result=$(echo $(systemd-analyze security | awk '/OK/ {ok++} {total++} END {print "OK: " ok " / Total: " total}'))
      echo $result

      
      ok=$(echo "$result" | awk '{print $3}')
      total=$(echo "$result" | awk '{print $5}')

      if [ "$ok" -eq "$total" ]; then
        urgency="normal"
      else
        urgency="critical"
      fi

      loginctl list-sessions --no-legend  | while IFS= read -r session; do
        echo "Processing session: $session"

        session_id=$(echo "$session" | awk '{print $1}')
        user_id=$(echo "$session" | awk '{print $2}')
        username=$(echo "$session" | awk '{print $3}')
        session_type=$(loginctl show-session "$session_id" -p Type | cut -d= -f2)

        if [[ "$session_type" == "wayland" || "$session_type" == "x11" ]]; then
          echo "GUI session detected: $session_type"

          export XDG_RUNTIME_DIR="/run/user/$user_id"
          export DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$(pgrep -u "$user_id" -n)/environ | tr -d '\0' | sed 's/DBUS_SESSION_BUS_ADDRESS=//')

          echo "XDG_RUNTIME_DIR: $XDG_RUNTIME_DIR"
          echo "DBUS_SESSION_BUS_ADDRESS: $DBUS_SESSION_BUS_ADDRESS"

          runuser -u $username -- notify-send --urgency=$urgency --category info "Systemd Security Check" "$result"

        else
          echo "Non-GUI session skipped: $session_type"
        fi
      done
    '';
    serviceConfig = {
      Type = "oneshot";
    };
    wantedBy = [ "multi-user.target" ];
  };

  systemd.timers.systemd-security-check = {
    description = "Daily systemd security check";
    enable = true;
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "1h";
      Unit = "systemd-security-check.service";
      Persistent = true;
    };
    wantedBy = [ "timers.target" ];
  };
}
