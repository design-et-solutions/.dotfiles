{
  modulesPath,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ../../nixos/disk-config.nix
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMc6jbhoDuKt0YOIF9prT4reT9WG6sP2sEFVj59loQwq me@desktop-hood"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAq7LsVEV+jw4yPpLyDc4XIS2yVmSJt0J24pS4BQYtGD me@laptop-work"
  ];

  services = {
    displayManager = {
      autoLogin.enable = true;
      autoLogin.user = "me";
    };
  };

  networking = {
    hosts = {
      "192.100.1.1" = [ "cdp.thales" ];
    };
  };

  systemd.services."rtsp-to-hls" = {
    # enable = false;
    description = "Middleware RTSP to HLS";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /var/www/html/hls";
      # ExecStart = "${pkgs.ffmpeg}/bin/ffmpeg -fflags nobuffer -flags low_delay -strict experimental -i rtsp://192.168.100.134:8554/vivatech-simu -c:v libx264 -preset ultrafast -tune zerolatency -x264-params keyint=20:min-keyint=20:scenecut=0 -g 20 -sc_threshold 0 -start_number 0 -an -f hls -hls_time 2 -hls_list_size 10 -hls_flags delete_segments+append_list+omit_endlist -hls_delete_threshold 2 /var/www/html/hls/stream.m3u8";
      ExecStart = "${pkgs.ffmpeg}/bin/ffmpeg -fflags nobuffer -flags low_delay -strict experimental -i rtsp://192.168.100.134:8554/vivatech-simu -c:v libx264 -preset ultrafast -tune zerolatency -g 30 -sc_threshold 0 -start_number 0 -f hls -hls_time 2 -hls_list_size 10 -hls_flags delete_segments+append_list+omit_endlist /var/www/html/hls/stream.m3u8";
      # ExecStart = "${pkgs.ffmpeg}/bin/ffmpeg -i rtsp://192.168.100.134:8554/vivatech-simu -c:v on -preset -g 30 -sc_threshold 0 -start_number 0 -f hls -hls_time 2 -hls_list_size 7 -hls_flags delete_segments+append_list+omit_endlist /var/www/html/hls/stream.m3u8";
      Restart = "always";
      RestartSec = "5s";
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts."localhost" = {
      locations."/" = {
        root = "/var/www/html";
        index = "index.html";
      };
      locations."/hls/" = {
        root = "/var/www/html";
        extraConfig = ''
          add_header Cache-Control no-cache;
          add_header Access-Control-Allow-Origin *;
          types {
            application/vnd.apple.mpegurl m3u8;
            video/mp2t ts;
          }
        '';
      };
    };
  };

  systemd.services."auto-web-1" = {
    description = "Run Firefox with a specific URL";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "me";
      ExecStart = "${pkgs.firefox}/bin/firefox --kiosk --new-instance -P p1 --class firefox-1 http://192.168.100.125:3001/left https://demo.astrautm.com";
      Restart = "always";
      RestartSec = "5s";
      Environment = [
        "DISPLAY=:0"
        "XDG_RUNTIME_DIR=/run/user/1000"
      ];
    };
  };

  systemd.services."auto-web-2" = {
    description = "Run Firefox with a specific URL";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "me";
      ExecStart = "${pkgs.firefox}/bin/firefox --kiosk --new-instance -P p2 --class firefox-2 http://192.168.100.125:3001/right";
      Restart = "always";
      RestartSec = "5s";
      Environment = [
        "DISPLAY=:0"
        "XDG_RUNTIME_DIR=/run/user/1000"
      ];
    };
  };

  services.touchegg.enable = true;

  services.xserver.windowManager.i3.extraSessionCommands = ''
    # Disable screensaver
    xset s off
    # Disable screen blanking
    xset -dpms
    xset s noblank

    # > xinput list
    xinput map-to-output 10 HDMI-1
    xinput map-to-output 11 HDMI-2
  '';

  home-manager.users.me =
    { pkgs, ... }:
    {
      xsession.windowManager.i3 = {
        enable = true;
        extraConfig = ''
          # Disable the i3 bar
          bar {
            mode hide
          }

          # Define workspaces
          workspace 1 output HDMI-1
          workspace 2 output HDMI-2

          # Assign Firefox instances to specific workspaces
          assign [class="firefox-1"] 1
          assign [class="firefox-2"] 2
          assign [class="SightCohoma"] 1

          # Set Firefox instances to fullscreen on startup
          for_window [class="firefox-1"] fullscreen enable
          for_window [class="SightCohoma"] fullscreen enable
          for_window [class="firefox-2"] fullscreen enable

          bindsym Tab fullscreen disabe; focus left; fullscreen enable 
          # bindsym Shift+Tab
        '';
      };

      home.file."start_sight_app.sh" = {
        text = ''
          export DISPLAY=:0
          xhost +local:docker

          # Stop and remove the container only if it exists
          docker stop sight-container
          docker container rm sight-container

          # Don't use `-it` for systemd services (no TTY)
          docker run \
            --network host \
            -e DISPLAY=$DISPLAY \
            -v /tmp/.X11-unix:/tmp/.X11-unix \
            --device /dev/dri:/dev/dri \
            --name sight-container sight-image
        '';
        executable = true;
      };

      home.file."stop_sight_app.sh" = {
        text = ''
          export DISPLAY=:0
          xhost +local:docker
          docker stop sight-container
          docker container rm sight-container
        '';
        executable = true;
      };

      home.file."change_tabs.sh" = {
        text = ''
          export DISPLAY=:0
          #!/bin/sh

          # Check if an argument is provided
          if [ -z "$1" ]; then
            echo "Usage: $0 <next|previous|number>"
            exit 1
          fi

          ACTION=$1

          # Get the window ID of the Firefox instance
          WINDOW_ID=$(wmctrl -lx | grep 'firefox-1' | awk '{print $1}')

          # Activate the window
          wmctrl -ia $WINDOW_ID

          # Perform the action based on the argument
          case $ACTION in
            next)
              # Switch to the next tab (Ctrl+Tab)
              xdotool key --window $WINDOW_ID Control+Tab
              ;;
            previous)
              # Switch to the previous tab (Ctrl+Shift+Tab)
              xdotool key --window $WINDOW_ID Control+Shift+Tab
              ;;
            *)
              # Switch to the next tab (Ctrl+number)
              xdotool key --window $WINDOW_ID Control+$ACTION
              ;;
          esac
        '';
        executable = true;
      };

      # Write touchegg.conf to the right place
      home.file.".config/touchegg/touchegg.conf".text = ''
        <touchégg>
          <settings>
            <property name="composed_gestures_time">100</property>
          </settings>
          <application name="All">
            <gesture type="PINCH" fingers="2" direction="IN">
              <action type="RUN_COMMAND">
                <repeat>true</repeat>
                <command>xdotool click 5</command>
              </action>
            </gesture>
             
            <gesture type="PINCH" fingers="2" direction="OUT">
              <action type="RUN_COMMAND">
                <repeat>true</repeat>
                <command>xdotool click 4</command>
              </action>
            </gesture>

            <gesture type="TAP" fingers="1" direction="">
              <action type="MOUSE_CLICK">BUTTON=1</action>
            </gesture>
          </application>

          <gesture type="SWIPE" fingers="3" direction="RIGHT">
              <action type="RUN_COMMAND">
                <repeat>true</repeat>
                <command>xdotool key Tab</command>
              </action>
          </gesture>

          <gesture type="SWIPE" fingers="3" direction="LEFT">
            <action type="SEND_KEYS">
              <repeat>true</repeat>
              <modifiers>xdotool key Tab</modifiers>
              <keys>1</keys>
            </action>
          </gesture>
        </touchégg>
      '';

      xsession.windowManager.i3.config.startup = [
        {
          command = "unclutter --timeout 0 --jitter 0 --hide-on-touch";
          always = true;
        }
        {
          command = "touchegg";
          always = true;
        }
      ];
    };

  systemd.services."thales-sight" = {
    description = "Run Thales App Sight";
    wantedBy = [ "multi-user.target" ];
    after = [ "auto-web-2.service" ];
    serviceConfig = {
      User = "me";
      ExecStart = "${pkgs.bash}/bin/bash /home/me/start_sight_app.sh";
      ExecStop = "${pkgs.bash}/bin/bash /home/me/stop_sight_app.sh";
      Restart = "always";
      RestartSec = "5s";
      Environment = [
        "DISPLAY=:0"
        "XDG_RUNTIME_DIR=/run/user/1000"
        "PATH=${pkgs.docker}/bin:${pkgs.xorg.xhost}/bin:$PATH"
      ];
    };
  };

  boot.kernel.sysctl = {
    "net.ipv4.conf.all.force_igmp_version" = 2;
  };

  environment.systemPackages = with pkgs; [
    xdotool
    libinput-gestures
    libinput
    touchegg
    wmctrl
    unclutter-xfixes
    nginx
    ffmpeg

    tcpdump
    natscli

    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    gst_all_1.gst-vaapi
    qt5.full
    xorg.libX11
    xorg.libxcb
    xorg.libXi
    xorg.libXcomposite
    xorg.xrandr
    xorg.xinput
    xorg.xmodmap
    xorg.xwininfo
    xorg.xhost
    fontconfig.dev
    freetype.dev
    xorg.libX11.dev
    xorg.libxcb.dev
    xorg.libXext.dev
    xorg.libXfixes.dev
    xorg.libXi.dev
    xorg.libXrender.dev
    xorg.libxcb.dev
    xorg.libXtst
  ];

  # Ensures dbus and polkit are working for user/system-level services
  services.dbus.enable = true;
  security.polkit.enable = true;

  # This ensures X11 sessions start correctly for polkit (esp. with i3)
  services.xserver.enable = true;

  # Required for polkit to identify users in graphical sessions
  services.xserver.displayManager.startx.enable = true;
}
