{ pkgs, ... }:
{
  systemd.services."ds-client" = {
    description = "Run React Client";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "me";
      WorkingDirectory = "/home/me/4757-R4-SWR/trunk-client";
      ExecStart = "${pkgs.nodejs}/bin/npm start -- -p 3001";
      Restart = "always";
      RestartSec = "5s";
      Environment = "PATH=/run/current-system/sw/bin:/bin:/usr/bin";
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
        "SSL_CRT_FILE=/home/me/gateway/fullchain.crt"
        "SSL_KEY_FILE=/home/me/gateway/gateway.key"
      ];
      ExecStart = "${pkgs.nix}/bin/nix-shell /home/me/gateway/shell.nix --run \"/home/me/gateway/gateway\"";
      Restart = "always";
      RestartSec = "5s";
    };
  };
}
