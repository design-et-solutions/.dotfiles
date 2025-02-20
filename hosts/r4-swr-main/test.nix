{ pkgs, ... }:
{
  systemd.services."test-rtsp-server" = {
    description = "Run RTSP Server";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      WorkingDirectory = "/home/me/poc/rtsp-server";
      ExecStart = "/run/current-system/sw/bin/nix-shell shell.nix --run './target/release/main'";
      Restart = "always";
      RestartSec = "5s";
    };
  };

  systemd.services."test-ws-server" = {
    description = "Run WS Server";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "me";
      WorkingDirectory = "/home/me/poc/rtsp-client";
      ExecStart = "/run/current-system/sw/bin/nix-shell shell.nix --pure --run 'node stream.js'";
      Restart = "always";
      RestartSec = "5s";
    };
  };

  systemd.services."test-client" = {
    description = "Run React Client";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "me";
      WorkingDirectory = "/home/me/poc/rtsp-client";
      ExecStart = "${pkgs.nodejs}/bin/npm start";
      Restart = "always";
      RestartSec = "5s";
      Environment = "PATH=/run/current-system/sw/bin:/bin:/usr/bin";
    };
  };
}
