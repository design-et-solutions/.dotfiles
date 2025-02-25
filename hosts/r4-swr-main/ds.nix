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
        "APP_PORT=3000"
        "RUST_LOG=INFO"
        "PRIVATE_KEY=/home/me/gateway/key.pem"
        "CERTIFICATE=/home/me/gateway/cert.pem"
      ];
      ExecStart = "${pkgs.nix}/bin/nix-shell /home/me/gateway/shell.nix --run \"/home/me/gateway/gateway\"";
      Restart = "always";
      RestartSec = "5s";
    };
  };
}
