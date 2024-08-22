{ ... }: {
  programs.waybar = {
    enable = true;
    style = ./style.css;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 40;
        spacing = 0; # Gaps between modules (0px) Adjusted in the css
        margin-top = 10;
        margin-bottom = 4;
        margin-left = 10;
        margin-right = 10;
        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
          "tray"
        ];
        modules-center = [
          "clock#time"
        ];
        modules-right = [
          "cpu"
          "memory"
          "temperature"
          "disk"
          "network" 
          "pulseaudio"
          "battery"
          "backlight" 
          "clock#date"
        ];
        "hyprland/workspaces" = {
          format = "{icon}:";
          all-outputs = true;
          sort-by-number = true;
          active-only = true;
          format-icons = {
            "1" = "01/10";
            "2" = "02/10";
            "3" = "03/10";
            "4" = "04/10";
            "5" = "05/10";
            "6" = "06/10";
            "7" = "07/10";
            "8" = "08/10";
            "9" = "09/10";
            "10" = "10/10";
          };
          disable-scroll = true;
        };
        "hyprland/window" = {
          format = "{}";
          separate-outputs = true;
          max-length = 35;
        };
        "cpu" = {
		  interval = 5;
		  tooltip = false;
		  format = "  {usage}%";
		  format-alt = "  {load}";
		  states = {
			warning = 70;
			critical = 90;
		  };
	    };
        "memory" = {
		  interval = 5;
		  format = "  {used:0.1f}G/{total:0.1f}G";
		  states = {
			warning = 70;
		    critical = 90;
		  };
		  tooltip = false;
	    };
        "temperature" = {
          # thermal-zone = 2;
          # hwmon-path" = /sys/class/hwmon/hwmon2/temp1_input";
          critical-threshold = 80;
          format-critical = "{icon} {temperatureC}°C";
          format = "{icon} {temperatureC}°C";
          format-icons = [
            ""
            ""
            ""
          ];
          interval = 2;
        };
        "disk" = {
          format = "  {percentage_used}% ({free})";
          interval = 2;
        };
        "network" = {
          # interface = "wlp2s0"; #(Optional) To force the use of this interface
          format = "↕ {bandwidthTotalBytes}";
          format-disconnected = "{icon} disconnected";
          format-wifi = "{icon}  {essid} ({signalStrength}%)";
          format-ethernet = "{icon} {ifname}: {ipaddr}/{cidr}";
          format-icons = {
            ethernet = "";
            disconnected = "⚠";
            wifi = "";
          };
          interval = 2;
        };
        "pulseaudio" = {
          # scroll-step = 1;
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}%";
          format-bluetooth-muted = "{icon}";
          format-muted = "{icon}";
          format-source = "{icon} {volume}%";
          format-source-muted = "{icon}";
          format-icons = {
            headphones = "";
            handsfree = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            source = "";
            source-muted = "";
            muted = "";
            bluetooth = "";
            bluetooth-muted = "";
            default = ["" "" ""];
          };
        };
        "backlight" = {
          # device = "acpi_video1";
          format = "{icon} {percent}%";
          format-alt = "no backlight";
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
          format = "{capacity}% {icon} ({time})";
		  format-time = "{H}:{M:02}";
		  format-charging = " {capacity}% ({time})";
		  format-charging-full = " {capacity}%";
		  format-full = "{icon} {capacity}%";
		  format-alt = "{icon} {power}W";
          format-icons = ["" "" "" "" ""];
		  tooltip = false;
          interval = 2;
        };
        "tray" = {
          icon-size = 21;
          spacing = 10;
        };
        "clock#time" = {
          timezone = "Europe/Paris";
		  interval = 10;
		  format = "{:%H:%M}";
		  tooltip = false;
	    };
	    "clock#date" = {
          timezone = "Europe/Paris";
		  interval = 20;
		  format = "󰃶 {:%e %b %Y}";
		  tooltip = false;
    	};
      };
    };
  };
}
