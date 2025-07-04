{ pkgs, ... }: {
  systemd.services."ds-client" = {
    description = "Run React Client";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      User = "me";
      WorkingDirectory = "/home/me/4757-R4-SWR/trunk-client";
      ExecStart = "${pkgs.nodejs}/bin/npm start -- -p 3001";
      Restart = "always";
      RestartSec = "5s";
      Environment = "PATH=/run/current-system/sw/bin:/bin:/usr/bin";
    };
  };

  systemd.services."ds-server-bis" = {
    description = "Run Server Bis";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Environment = [
        "APP_HOST=0.0.0.0"
        "APP_PORT=4000"
        "RUST_LOG=INFO"
        "SSL_CRT_FILE=/home/me/gateway-bis/fullchain.crt"
        "SSL_KEY_FILE=/home/me/gateway-bis/gateway.key"
      ];
      ExecStart = ''
        ${pkgs.nix}/bin/nix-shell /home/me/gateway-bis/shell.nix --run "/home/me/gateway-bis/gateway"'';
      Restart = "always";
      RestartSec = "5s";
    };
  };
}
