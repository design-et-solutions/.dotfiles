{ pkgs, ... }:
{
  systemd.services."docker-compose-v2x-edge-node" = {
    description = "Run Docker for v2x edge node";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      EnvironmentFile = [
        "/home/me/4757-R4-SWR/orange/DOTenv"
        "/home/me/4757-R4-SWR/orange/credentials"
      ];
      ExecStartPre = "${pkgs.bash}/bin/bash -c 'echo $DOCK_PASS | ${pkgs.docker}/bin/docker login -u $DOCK_USER --password-stdin $DOCK_REMOTE'";
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose --project-name $DOCK_PROJECT -f /home/me/4757-R4-SWR/orange/docker-compose-v2x-edge-node.yml up";
      ExecStartPost = "${pkgs.docker}/bin/docker logout";
      Restart = "always";
      RestartSec = "5s";
    };
  };

  systemd.services."docker-compose-allog" = {
    description = "Run Docker for allog";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      EnvironmentFile = [
        "/home/me/4757-R4-SWR/orange/DOTenv"
        "/home/me/4757-R4-SWR/orange/credentials"
      ];
      ExecStartPre = "${pkgs.bash}/bin/bash -c 'echo $DOCK_PASS | ${pkgs.docker}/bin/docker login -u $DOCK_USER --password-stdin $DOCK_REMOTE'";
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose --project-name $DOCK_PROJECT -f /home/me/4757-R4-SWR/orange/docker-compose-allog.yml up";
      ExecStartPost = "${pkgs.docker}/bin/docker logout";
      Restart = "always";
      RestartSec = "5s";
    };
  };
}
