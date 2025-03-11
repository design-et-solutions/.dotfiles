{ pkgs, ... }:
{
  systemd.services."auto-web-1" = {
    description = "Run Firefox with a specific URL";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "me";
      ExecStart = "${pkgs.firefox}/bin/firefox http://localhost:3000/left";
      Restart = "always";
      RestartSec = "5s";
      Environment = [
        "WAYLAND_DISPLAY=wayland-1"
        "XDG_RUNTIME_DIR=/run/user/1000"
        "MOZ_ENABLE_WAYLAND=1"
        "GDK_BACKEND=wayland"
      ];
    };
  };

  systemd.services."auto-web-2" = {
    description = "Run Firefox with a specific URL";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "me";
      ExecStart = "${pkgs.firefox}/bin/firefox http://localhost:3000/right";
      Restart = "always";
      RestartSec = "5s";
      Environment = [
        "WAYLAND_DISPLAY=wayland-1"
        "XDG_RUNTIME_DIR=/run/user/1000"
        "MOZ_ENABLE_WAYLAND=1"
        "GDK_BACKEND=wayland"
      ];
    };
  };

  systemd.services."ds-client" = {
    description = "Run React Client";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "me";
      WorkingDirectory = "/home/me/4757-R4-SWR/trunk-client";
      ExecStart = "${pkgs.nodejs}/bin/npm start -- -p 3000";
      Restart = "always";
      RestartSec = "5s";
      Environment = "PATH=/run/current-system/sw/bin:/bin:/usr/bin";
    };
  };
}
