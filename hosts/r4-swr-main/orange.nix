{ pkgs, ... }:
{
  # Login
  # docker login platform-mce.orange-labs.fr:2424
  # softwrep/worldWild

  # docker image ls
  # docker rmi $(docker images -a -q)
  # docker rm if not able to rmi

  # ${pkgs.docker-compose}/bin/docker-compose --project-name $DOCK_PROJECT -f /home/me/4757-R4-SWR/orange-storage/docker-compose-v2x-edge-node.yml up
  systemd.services."orange-golem-swr" = {
    description = "Run Docker golem-swr";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.docker}/bin/docker run -d platform-mce.orange-labs.fr:2424/orange/golem_swr:latest";
      Restart = "always";
      RestartSec = "5s";
    };
  };
  systemd.services."orange-allog-swr" = {
    description = "Run Docker allog-swr";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.docker}/bin/docker run -d platform-mce.orange-labs.fr:2424/orange/orange_allog_swr:latest";
      Restart = "always";
      RestartSec = "5s";
    };
  };
  systemd.services."orange-mosquitto-swr" = {
    description = "Run Docker mosquitto-swr";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.docker}/bin/docker run -d platform-mce.orange-labs.fr:2424/orange/orange_mosquitto_swr:latest";
      Restart = "always";
      RestartSec = "5s";
    };
  };
}
