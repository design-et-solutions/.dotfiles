{ ... }: {
  programs.waybar = {
    enable = true;
    style = ./style.css;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 32;
        spacing = 0; # Gaps between modules (0px) Adjusted in the css
        margin-top = 0;
        margin-left = 10;
        margin-right = 10;
        modules-left = [
          "hyprland/workspaces"
          "cpu"
          "memory"
          "temperature"
          "disk"
        ];
        "hyprland/workspaces" = {
          format = "";
          format-icons = {
            active = "";
            default = "";
          };
          disable-scroll = true;
        };
        "cpu" = {
          format = "{usage}%  ";
          interval = 2;
        };
        "memory" = {
          format = "{}% ";
          interval = 2;
        };
        "temperature" = {
          # thermal-zone = 2;
          # hwmon-path" = /sys/class/hwmon/hwmon2/temp1_input";
          critical-threshold = 80;
          format-critical = "{temperatureC}°C {icon}";
          format = "{temperatureC}°C {icon}";
          format-icons = [
            ""
            ""
            ""
          ];
          interval = 2;
        };
        "disk" = {
          format = "{percentage_used}%   ({free})";
          interval = 2;
        };
        modules-center = [
          "hyprland/window"
        ];
        "hyprland/window" = {
          format = "{}";
          separate-outputs = true;
          max-length = 35;
        };
        modules-right = [
          "network" 
          "pulseaudio"
          "tray"
          "backlight" 
          "battery"
          "clock"
        ];
        "network" = {
          # interface = "wlp2s0"; #(Optional) To force the use of this interface
          format = "{bandwidthTotalBytes}↕";
          format-disconnected = "disconnected {icon}";
          format-wifi = "{essid} ({signalStrength}%) {icon}";
          format-ethernet = "{ifname}: {ipaddr}/{cidr} {icon}";
          format-icons = {
            ethernet = "";
            disconnected = "⚠";
            wifi = "";
          };
          interval = 2;
        };
        "pulseaudio" = {
          # scroll-step = 1;
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}";
          format-bluetooth-muted = "";
          format-muted = "";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphones = "";
            handsfree = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
        };
        "backlight" = {
          # device = "acpi_video1";
          format = "{percent}% {icon}";
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
          interval = 2;
        };
        "battery" = {
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          # format-good = ""; # An empty format will hide the module
          # format-full = "";
          format-icons = ["" "" "" "" ""];
          interval = 2;
        };
        "tray" = {
          icon-size = 21;
          spacing = 10;
        };
        "clock" = {
          timezone = "Europe/Paris";
          format = " {:%d <small>%a</small> %H:%M}";
          format-alt = " {:%A %B %d %Y (%V) | %r}";
          calendar-weeks-pos = "right";
          today-format = "<span color='#f38ba8'><b><u>{}</u></b></span>";
          format-calendar = "<span color='#f2cdcd'><b>{}</b></span>";
          format-calendar-weeks = "<span color='#94e2d5'><b>W{:%U}</b></span>";
          format-calendar-weekdays = "<span color='#f9e2af'><b>{}</b></span>";
          interval = 60;
        };
      };
    };
  };
}
