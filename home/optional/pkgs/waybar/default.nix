{ ... }: {
  programs.waybar = {
    enable = true;
    style = ./waybar.css;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 32;
        modules-left = [
          "sway/workspaces"
          "sway/mode"
        ];
        modules-center = [
          "sway/window"
        ];
        modules-right = [
          # "tray"
          # "pulseaudio" 
          "network" 
          "cpu"
          "memory"
          "temperature" 
          "backlight" 
          "battery"
          "clock"
        ];
        
        "sway/workspaces" = {
          disable-scroll = true;
          disable-markup = false;
          all-outputs = true;
          format = "  {icon}  ";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "10" = "";
            "4" = "";
            "5" = "";
            focused = "";
            default = "";
          };
        };
        "sway/mode" = {
          format = "<span style=\"italic\">{}</span>";
        };
        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        "tray" = {
          icon-size = 21;
          spacing = 10;
        };
        "clock" = {
          tooltip-format = "{:%Y-%m-%d | %H:%M}";
          format-alt = "{:%Y-%m-%d}";
        };
        "cpu" = {
          format = "{usage}% ";
        };
        "memory" = {
          format = "{}% ";
        };
        "temperature" = {
          # thermal-zone = 2;
          # hwmon-path" = /sys/class/hwmon/hwmon2/temp1_input";
          critical-threshold = 80;
          # format-critical = "{temperatureC}°C ";
          format = "{temperatureC}°C ";
        };
        "backlight" = {
          # device = "acpi_video1";
          format = "{percent}% {icon}";
          states = [0 50];
          format-icons = ["" ""];
        };
        "battery" = {
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          # format-good = ""; # An empty format will hide the module
          # format-full = "";
          format-icons = ["" "" "" "" ""];
        };
        "network" = {
          # interface = "wlp2s0";
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ifname}: {ipaddr}/{cidr} ";
          format-disconnected = "Disconnected ⚠";
          interval = 7;
        };
        "pulseaudio" = {
          # scroll-step = 1;
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}";
          format-muted = "";
          format-icons = {
            headphones = "";
            handsfree = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" ""];
          };
          on-click = "pavucontrol";
        };
      };
    };
  };
}
