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

  environment.variables = {
    MOZ_USE_XINPUT2 = "1";
  };

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
            mode invisible
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
          for_window [class="firefox-2"] fullscreen enable
        '';
      };

      home.file."start_sight_app.sh" = {
        text = ''
          export DISPLAY=:0
          xhost +local:docker
          docker stop sight-container
          docker container rm sight-container
          docker run -d -it \
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
            <property name="composed_gestures_time">111</property>
          </settings>
          <application name="All">
            <gesture type="DRAG" fingers="1" direction="ALL">
              <action type="DRAG_AND_DROP">BUTTON=1</action>
            </gesture>
            <gesture type="DRAG" fingers="4" direction="DOWN">
              <action type="SEND_KEYS">Super+a</action>
            </gesture>
            <gesture type="DRAG" fingers="4" direction="UP">
              <action type="SEND_KEYS">Super+s</action>
            </gesture>
            <gesture type="DRAG" fingers="4" direction="RIGHT">
              <action type="SEND_KEYS">Super+Left</action>
            </gesture>
            <gesture type="DRAG" fingers="4" direction="LEFT">
              <action type="SEND_KEYS">Super+Right</action>
            </gesture>
            <gesture type="DRAG" fingers="3" direction="UP">
              <action type="MAXIMIZE_RESTORE_WINDOW"></action>
            </gesture>
            <gesture type="DRAG" fingers="3" direction="DOWN">
              <action type="MINIMIZE_WINDOW"></action>
            </gesture>
            <gesture type="DRAG" fingers="3" direction="RIGHT">
              <action type="SEND_KEYS">Control+Super+Right</action>
            </gesture>
            <gesture type="DRAG" fingers="3" direction="LEFT">
              <action type="SEND_KEYS">Control+Super+Left</action>
            </gesture>
            <gesture type="DRAG" fingers="2" direction="ALL">
              <action type="SCROLL">SPEED=7:INVERTED=true</action>
            </gesture>

            <gesture type="PINCH" fingers="2" direction="IN">
              <action type="SEND_KEYS">
                <modifiers>Control_L</modifiers>
                <keys>minus</keys>
                <on>begin</on>
              </action>
            </gesture>

            <gesture type="PINCH" fingers="2" direction="OUT">
              <action type="SEND_KEYS">
                <modifiers>Control_L</modifiers>
                <keys>equal</keys>
                <on>begin</on>
              </action>
            </gesture>

            <gesture type="TAP" fingers="3" direction="">
              <action type="MOUSE_CLICK">BUTTON=2</action>
            </gesture>
            <gesture type="TAP" fingers="2" direction="">
              <action type="MOUSE_CLICK">BUTTON=3</action>
            </gesture>
            <gesture type="TAP" fingers="1" direction="">
              <action type="MOUSE_CLICK">BUTTON=1</action>
            </gesture>
          </application>
          <application name="Gwenview, Shotwell, Evince">
            <gesture type="ROTATE" fingers="2" direction="LEFT">
              <action type="SEND_KEYS">Control+L</action>
            </gesture>
            <gesture type="PINCH" fingers="2" direction="IN">
              <action type="SEND_KEYS">Control+KP_Add</action>
            </gesture>
            <gesture type="PINCH" fingers="2" direction="OUT">
              <action type="SEND_KEYS">Control+KP_Subtract</action>
            </gesture>
            <gesture type="ROTATE" fingers="2" direction="RIGHT">
              <action type="SEND_KEYS">Control+R</action>
            </gesture>
          </application>
          <application name="Dolphin, Midori, Chromium-browser, Chrome, Firefox">
            <gesture type="DRAG" fingers="5" direction="RIGHT">
              <action type="SEND_KEYS">Alt+Home</action>
            </gesture>
            <gesture type="DRAG" fingers="5" direction="ALL">
              <action type="SEND_KEYS">Control+Next</action>
            </gesture>
          </application>
        </touchégg>
      '';

      xsession.windowManager.i3.config.startup = [
        {
          command = "touchegg";
          always = true;
        }
      ];
    };

  # systemd.services."thales-sight" = {
  #   description = "Run Thales App Sight";
  #   wantedBy = [ "multi-user.target" ];
  #   serviceConfig = {
  #     User = "me";
  #     ExecStart = "${pkgs.bash}/bin/bash /home/me/thales_sight_docker_vivatech/launch_sight_docker.sh";
  #     Restart = "on-failure";
  #     RestartSec = "5s";
  #     Environment = [
  #       "DISPLAY=:0"
  #       "XDG_RUNTIME_DIR=/run/user/1000"
  #       "PATH=${pkgs.docker}/bin:${pkgs.xorg.xhost}/bin:$PATH"
  #     ];
  #   };
  # };

  boot.kernel.sysctl = {
    "net.ipv4.conf.all.force_igmp_version" = 2;
  };

  services.touchegg.enable = true;

  environment.systemPackages = with pkgs; [
    xdotool
    libinput-gestures
    libinput
    touchegg
    wmctrl

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
}
