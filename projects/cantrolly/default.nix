{ lib, pkgs, ... }:{
  # dependency
  environment = {
    etc = {
      "cantrolly/.env".source = ./.env;
      "cantrolly/cantrolly".source = ../../../cantrolly;
    };
  }; 

  systemd.services = {
    cantrolly = {
      description = "Service Cantrolly";
      after = [ "network.target" "fatherhood-gateway.service" ];
      requires = [ "fatherhood-gateway.service" ];
      serviceConfig = {
        ExecStart = "/etc/cantrolly/bin";
        Restart = "always";
        RestartSec = "30s";
        EnvironmentFile= "/etc/cantrolly/.env";
      };
    };
  };
}
