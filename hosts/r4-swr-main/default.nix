{ pkgs, lib, ... }:
{
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  time.timeZone = "Europe/Paris";

  networking = {
    hostName = "r4-swr-main";
  };

  services.xserver.displayManager.autoLogin = {
    enable = true;
    user = "me";
  };

  systemd.services."test-web" = {
    description = "Run Firefox with a specific URL";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "me";
      ExecStart = "${pkgs.firefox}/bin/firefox http://localhost:3000";
      Restart = "always";
      RestartSec = "5s";
      Environment = [
        "WAYLAND_DISPLAY=wayland-1"
        "XDG_RUNTIME_DIR=/run/user/1000"
      ];
    };
  };

  systemd.services."test-rtsp-server" = {
    description = "Run RTSP Server";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      WorkingDirectory = "/home/me/poc/rtsp-server";
      ExecStart = "nix-shell shell.nix --run './target/release/main'";
      Restart = "always";
      RestartSec = "5s";
    };
  };

  systemd.services."test-ws-server" = {
    description = "Run WS Server";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      WorkingDirectory = "/home/me/poc/rtsp-client";
      ExecStart = "nix-shell shell.nix --run 'node stream.js'";
      Restart = "always";
      RestartSec = "5s";
    };
  };

  systemd.services."test-client" = {
    description = "Run React Client";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      WorkingDirectory = "/home/me/poc/rtsp-client";
      ExecStart = "${pkgs.nodejs}/bin/npm start";
      Restart = "always";
      RestartSec = "5s";
    };
  };
}
