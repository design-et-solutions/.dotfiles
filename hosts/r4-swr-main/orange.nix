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
      ExecStart = "docker run -d platform-mce.orange-labs.fr:2424/orange/golem_swr:latest";
      Restart = "always";
      RestartSec = "5s";
    };
  };
  systemd.services."orange-allog-swr" = {
    description = "Run Docker allog-swr";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "docker run -d platform-mce.orange-labs.fr:2424/orange/orange_allog_swr:latest";
      Restart = "always";
      RestartSec = "5s";
    };
  };
  systemd.services."orange-mosquitto-swr" = {
    description = "Run Docker mosquitto-swr";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "docker run -d platform-mce.orange-labs.fr:2424/orange/orange_mosquitto_swr:latest";
      Restart = "always";
      RestartSec = "5s";
    };
  };
}
