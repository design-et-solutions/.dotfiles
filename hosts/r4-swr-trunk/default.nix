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
      ExecStart = "${pkgs.firefox}/bin/firefox --new-instance -P p1 --class firefox-1 http://192.168.100.125:3001/left";
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
      ExecStart = "${pkgs.firefox}/bin/firefox --new-instance -P p2 --class firefox-2 http://192.168.100.125:3001/right";
      Restart = "always";
      RestartSec = "5s";
      Environment = [
        "DISPLAY=:0"
        "XDG_RUNTIME_DIR=/run/user/1000"
      ];
    };
  };

  environment.variables = {
    # GST_PLUGIN_SYSTEM_PATH_1_0 = "${pkgs.gst_all_1.gstreamer.out}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-base}/lib/gstreamer-1.0:${pkgs.gst_all_1.gst-plugins-good}/lib/gstreamer-1.0";
  };

  environment.systemPackages = with pkgs; [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav

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

    # xorg.libxcb-glx.dev
    # xorg.libxcb-keysyms.dev
    # xorg.libxcb-image.dev
    # xorg.libxcb-shm.dev
    # xorg.libxcb-icccm.dev
    # xorg.libxcb-sync.dev
    # xorg.libxcb-xfixes.dev
    # xorg.libxcb-shape.dev
    # xorg.libxcb-randr.dev
    # xorg.libxcb-render-util.dev
    # xorg.libxcb-xinerama.dev
    # libxkbcommon.dev
    # libxkbcommon-x11.dev

    natscli
  ];

  home-manager.users.me =
    { pkgs, ... }:
    {
      xsession.windowManager.i3.extraConfig = ''
        # Define workspaces
        workspace 1 output HDMI-1
        workspace 2 output HDMI-2

        # Assign Firefox instances to specific workspaces
        assign [class="firefox-1"] 1
        assign [class="firefox-2"] 2

        # Set Firefox instances to fullscreen on startup
        for_window [class="firefox-1"] fullscreen enable
        for_window [class="firefox-2"] fullscreen enable
      '';
    };
}
