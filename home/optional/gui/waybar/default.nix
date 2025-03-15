{ pkgs, ... }:
{
  # https://man.archlinux.org/man/waybar-custom.5.en
  # debug
  # > waybar -l trace
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        margin-top = 5;
        margin-bottom = 0;
        margin-left = 5;
        margin-right = 5;
        modules-left = [
          "clock#date"
          "clock#time"
          "network"
          "custom/tx-net"
          "custom/rx-net"
          "custom/unread-mail"
        ];
        modules-center = [
          "custom/spotify"
        ];
        modules-right = [
          "battery"
          "backlight"
          "pulseaudio"
          "custom/gpu"
          "cpu"
          "memory"
          "temperature"
          "disk"
        ];
        "cpu" = {
          format = "  {usage}%";
          interval = 1;
          tooltip = false;
        };
        "memory" = {
          format = "󰒋  {used:0.1f}Go / {total:0.1f}Go";
          interval = 1;
          tooltip = false;
        };
        "temperature" = {
          format = "{icon} {temperatureC}°C";
          format-icons = {
            default = [
              ""
              ""
              ""
            ];
          };
          interval = 1;
          tooltip = false;
        };
        "disk" = {
          format = "󰟀  {used} / {free}";
          interval = 1;
          tooltip = false;
        };
        "network" = {
          format-disconnected = "{icon} disconnected";
          format-wifi = "{icon} {essid} ({signalStrength}%) 󰑹 {ifname}";
          format-ethernet = "{icon} {ifname}: {ipaddr}/{cidr}";
          format-icons = {
            ethernet = " ";
            disconnected = " ";
            wifi = " ";
          };
          interval = 1;
          tooltip = false;
        };
        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon}  {volume}% {desc}";
          format-muted = "";
          format-icons = {
            headphones = " ";
            handsfree = " ";
            headset = " ";
            phone = " ";
            phone-muted = " ";
            portable = " ";
            car = " ";
            default = [
              " "
              " "
            ];
          };
          scroll-step = 1;
          tooltip = false;
        };
        "backlight" = {
          format = "{icon} {percent}%";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
          ];
          interval = 1;
          tooltip = false;
        };
        "battery" = {
          format = "{capacity}% {icon} ({time})";
          format-time = "{H}:{M:02}";
          format-charging = "{icon} {capacity}% ({time})";
          format-charging-full = "{icon} {capacity}%";
          format-full = "{icon} {capacity}%";
          format-icons = {
            charging = " ";
            charging-full = " ";
            default = [
              " "
              " "
              " "
              " "
              " "
            ];
          };
          tooltip = false;
          interval = 1;
        };
        "clock#time" = {
          timezone = "Europe/Paris";
          interval = 10;
          format = "{:%H:%M}";
          tooltip = false;
        };
        "clock#date" = {
          format = " {:%e %b %Y}";
          timezone = "Europe/Paris";
          interval = 240;
          tooltip = false;
        };
        "custom/spotify" = {
          format = "{icon} {}";
          format-icons = {
            Paused = "";
            Playing = "";
          };
          return-type = "json";
          tooltip = false;
          interval = 1;
          exec = "${pkgs.writeShellScript "spotify-player" ''
            playerctl -p spotify metadata --format '{"text": "{{artist}} - {{title}}", "alt": "{{status}}"}'
          ''}";
          exec-if = "${pkgs.writeShellScript "check-spotify" ''
            playerctl -p spotify status
          ''}";
        };
        "custom/gpu" = {
          format = "{icon} {}";
          format-icons = {
            running = "󰢮 ";
          };
          return-type = "json";
          tooltip = false;
          interval = 1;
          exec = "${pkgs.writeShellScript "gpu-usage" ''
            GPU_USAGE=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits -i 0)
            echo "{\"text\": \"$GPU_USAGE%\", \"alt\": \"running\"}"
          ''}";
          exec-if = "${pkgs.writeShellScript "check-gpu" ''
            nvidia-smi
          ''}";
        };
        "custom/tx-net" = {
          format = "{icon} {}";
          format-icons = {
            default = "";
          };
          return-type = "json";
          tooltip = false;
          interval = 1;
          exec = "${pkgs.writeShellScript "net-tx" ''
            INTERFACE=$(ip route get 1.1.1.1 | grep -oP 'dev\s+\K[^ ]+')
            NET_TX1=$(ifstat -j | jq ".kernel.$INTERFACE.tx_bytes")
            sleep 1
            NET_TX2=$(ifstat -j | jq ".kernel.$INTERFACE.tx_bytes")
            NET_TX=$((NET_TX2 - NET_TX1))
            if [ $NET_TX -ge 1073741824 ]; then
              RATE=$(echo "scale=2; $NET_TX / 1073741824" | bc)
              UNIT="GB/s"
            elif [ $NET_TX -ge 1048576 ]; then
              RATE=$(echo "scale=2; $NET_TX / 1048576" | bc)
              UNIT="MB/s"
            elif [ $NET_TX -ge 1024 ]; then
              RATE=$(echo "scale=2; $NET_TX / 1024" | bc)
              UNIT="KB/s"
            else
              RATE=$NET_TX
              UNIT="B/s"
            fi
            echo "{\"text\": \"$RATE $UNIT\"}"
          ''}";
          exec-if = "${pkgs.writeShellScript "check-interface" ''
            INTERFACE_COUNT=$(ip route get 1.1.1.1 | grep -oP 'dev\s+\K[^ ]+' | wc -l)
            if [[ $INTERFACE_COUNT -gt 0 ]]; then
              exit 0
            else
              exit 1
            fi
          ''}";
        };
        "custom/rx-net" = {
          format = "{icon} {}";
          format-icons = {
            default = "";
          };
          return-type = "json";
          tooltip = false;
          interval = 1;
          exec = "${pkgs.writeShellScript "net-rx" ''
            INTERFACE=$(ip route get 1.1.1.1 | grep -oP 'dev\s+\K[^ ]+')
            NET_RX1=$(ifstat -j | jq ".kernel.$INTERFACE.rx_bytes")
            sleep 1
            NET_RX2=$(ifstat -j | jq ".kernel.$INTERFACE.rx_bytes")
            NET_RX=$((NET_RX2 - NET_RX1))
            if [ $NET_RX -ge 1073741824 ]; then
              RATE=$(echo "scale=2; $NET_RX / 1073741824" | bc)
              UNIT="GB/s"
            elif [ $NET_RX -ge 1048576 ]; then
              RATE=$(echo "scale=2; $NET_RX / 1048576" | bc)
              UNIT="MB/s"
            elif [ $NET_RX -ge 1024 ]; then
              RATE=$(echo "scale=2; $NET_RX / 1024" | bc)
              UNIT="KB/s"
            else
              RATE=$NET_RX
              UNIT="B/s"
            fi
            echo "{\"text\": \"$RATE $UNIT\"}"
          ''}";
          exec-if = "${pkgs.writeShellScript "check-interface" ''
            INTERFACE_COUNT=$(ip route get 1.1.1.1 | grep -oP 'dev\s+\K[^ ]+' | wc -l)
            if [[ $INTERFACE_COUNT -gt 0 ]]; then
              exit 0
            else
              exit 1
            fi
          ''}";
        };
        "custom/unread-mail" = {
          format = "{icon} {}";
          format-icons = {
            no-empty = "󰻧 ";
            empty = "󰻩 ";
          };
          return-type = "json";
          tooltip = false;
          interval = 1;
          exec = "${pkgs.writeShellScript "unread-mail" ''
            UNREAD_MAIL=$(/etc/scripts/misc/mailchecker.fish | tail -n 1)
            if [[ $UNREAD_MAIL  -gt 0 ]]; then
              ALT="no-empty"
            else
              ALT="empty"
            fi
            echo "{\"text\": \"$UNREAD_MAIL\", \"alt\": \"$ALT\"}"

          ''}";
          exec-if = "${pkgs.writeShellScript "check-interface" ''
            MAIL_ACCOUNT_COUNT=$(/etc/scripts/misc/mailchecker.fish | wc -l)
            if [[ $MAIL_ACCOUNT_COUNT  -gt 1 ]]; then
              exit 0
            else
              exit 1
            fi
          ''}";
        };
      };
    };
  };

  xdg.configFile."waybar/theme".source = ./theme;

  home.file.".scripts/gui/waybar/self.fish" = {
    source = builtins.toString ../../../../scripts/gui/waybar/self.fish;
    executable = true;
  };
}
