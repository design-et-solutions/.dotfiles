{ pkgs, ... }:
{
  # Login
  # docker login platform-mce.orange-labs.fr:2424
  # softwrep/worldWild

  # docker image ls
  # docker rmi $(docker images -a -q)
  # docker rm if not able to rmi

  systemd.services."orange-golem-swr" = {
    description = "Run Docker golem-swr";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      EnvironmentFile = [
        "/home/me/4757-R4-SWR/orange-storage/DOTenv"
        "/home/me/4757-R4-SWR/orange-storage/credentials"
      ];
      ExecStart = "${pkgs.docker}/bin/docker run platform-mce.orange-labs.fr:2424/orange/golem_swr:latest";
      Restart = "always";
      RestartSec = "5s";
    };
  };
  systemd.services."orange-allog-swr" = {
    description = "Run Docker allog-swr";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      EnvironmentFile = [
        "/home/me/4757-R4-SWR/orange-storage/DOTenv"
        "/home/me/4757-R4-SWR/orange-storage/credentials"
      ];
      ExecStart = "${pkgs.docker}/bin/docker run platform-mce.orange-labs.fr:2424/orange/orange_allog_swr:latest";
      Restart = "always";
      RestartSec = "5s";
    };
  };
  systemd.services."orange-mosquitto-swr" = {
    description = "Run Docker mosquitto-swr";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      EnvironmentFile = [
        "/home/me/4757-R4-SWR/orange-storage/DOTenv"
        "/home/me/4757-R4-SWR/orange-storage/credentials"
      ];
      ExecStart = "${pkgs.docker}/bin/docker run platform-mce.orange-labs.fr:2424/orange/orange_mosquitto_swr:latest";
      Restart = "always";
      RestartSec = "5s";
    };
  };
  # # ${pkgs.docker-compose}/bin/docker-compose --project-name $DOCK_PROJECT -f /home/me/4757-R4-SWR/orange-storage/docker-compose-v2x-edge-node.yml pull
  # # ${pkgs.docker-compose}/bin/docker-compose --project-name $DOCK_PROJECT -f /home/me/4757-R4-SWR/orange-storage/docker-compose-v2x-edge-node.yml up
  # systemd.services."docker-compose-v2x-edge-node" = {
  #   description = "Run Docker for v2x edge node";
  #   wantedBy = [ "multi-user.target" ];
  #   serviceConfig = {
  #     EnvironmentFile = [
  #       "/home/me/4757-R4-SWR/orange-storage/DOTenv"
  #       "/home/me/4757-R4-SWR/orange-storage/credentials"
  #     ];
  #     ExecStartPre = "${pkgs.bash}/bin/bash -c '${pkgs.coreutils}/bin/echo $DOCK_PASS | ${pkgs.docker}/bin/docker login -u $DOCK_USER --password-stdin $DOCK_REMOTE'";
  #     ExecStart = "";
  #     ExecStartPost = "${pkgs.docker}/bin/docker logout";
  #     Restart = "always";
  #     RestartSec = "5s";
  #   };
  # };
  #
  # # ${pkgs.docker-compose}/bin/docker-compose --project-name $DOCK_PROJECT -f /home/me/4757-R4-SWR/orange-storage/docker-compose-allog.yml pull
  # # ${pkgs.docker-compose}/bin/docker-compose --project-name $DOCK_PROJECT -f /home/me/4757-R4-SWR/orange-storage/docker-compose-allog.yml up
  # systemd.services."docker-compose-allog" = {
  #   description = "Run Docker for allog";
  #   wantedBy = [ "multi-user.target" ];
  #   serviceConfig = {
  #     EnvironmentFile = [
  #       "/home/me/4757-R4-SWR/orange-storage/DOTenv"
  #       "/home/me/4757-R4-SWR/orange-storage/credentials"
  #     ];
  #     ExecStartPre = "${pkgs.bash}/bin/bash -c '${pkgs.coreutils}/bin/echo $DOCK_PASS | ${pkgs.docker}/bin/docker login -u $DOCK_USER --password-stdin $DOCK_REMOTE'";
  #     ExecStart = "";
  #     ExecStartPost = "${pkgs.docker}/bin/docker logout";
  #     Restart = "always";
  #     RestartSec = "5s";
  #   };
  # };
}
