{ pkgs, ... }: {
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
        ];
        modules-center = [
          "custom/spotify"
        ];
        modules-right = [
          "battery"
          "backlight" 
          "pulseaudio"
          "cpu"
          "memory"
          "temperature"
          "disk"
        ];
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
          format = "{icon} {volume}%";
          format-bluetooth = "{icon}  {volume}% {desc}";
          format-muted = "";
          format-icons = {
            headphones = "";
            handsfree = "";
            headset = "";
            phone = "";
            phone-muted = "";
            portable = "";
            car = "";
            default = ["" ""];
          };
          scroll-step = 1;
          on-click = "pavucontrol";
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
        "clock#time" = {
          # timezone = "Europe/Paris";
		  interval = 10;
		  format = "{:%H:%M}";
		  tooltip = false;
	    };
	    "clock#date" = {
          # timezone = "Europe/Paris";
		  interval = 20;
		  format = "󰃶 {:%e %b %Y}";
		  tooltip = false;
    	};
        "custom/spotify" = {
          format = " {}";
          return-type = "json";
          interval = 1;
          exec = "${pkgs.writeShellScript "spotify-waybar" ''
            ${pkgs.playerctl}/bin/playerctl -p spotify metadata --format '{"text": "{{artist}} - {{title}}", "tooltip": "{{title}} by {{artist}} on {{album}}", "alt": "{{status}}", "class": "{{status}}"}'
          ''}";
          exec-if = "${pkgs.playerctl}/bin/playerctl -p spotify status";
        };
      };
    };
  };

  xdg.configFile."waybar/theme".source = ./theme;

  home.file.".scripts/waybar.fish" = {
      source = builtins.toString ../../../scripts/waybar.fish;
      executable = true;
  };
}
