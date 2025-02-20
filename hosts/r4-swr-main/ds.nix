{ pkgs, ... }:
{
  systemd.services."auto-web" = {
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

  systemd.services."ds-server" = {
    description = "Run Server";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Environment = [
        "APP_HOST=0.0.0.0"
        "APP_PORT=8080"
        "RUST_LOG=INFO"
        "PRIVATE_KEY=/home/me/Manager/core/gateway/key.pem"
        "CERTIFICATE=/home/me/Manager/core/gateway/cert.pem"
        "TRACKER_HOST=0.0.0.0"
        "TRACKER_PORT=50200"
      ];
      ExecStart = "${pkgs.nix}/bin/nix-shell /home/me/Manager/core/gateway/nix/shell.nix --run \"/home/me/Manager/core/gateway/target/release/gateway\"";
      Restart = "always";
      RestartSec = "5s";
    };
  };
}
