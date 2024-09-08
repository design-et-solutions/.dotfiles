{ pkgs, ... }:{
  # dependency
  environment = {
    etc = {
      "fatherhood/.env".source = ./.env;
      "fatherhood/gateway".source = ./gateway;
      "fatherhood/registry".source = ./registry;
      "fatherhood/visionary".source = ./visionary;
      "fatherhood/sonify".source = ./sonify;
      "fatherhood/cli".source = ./cli;
    };
    systemPackages = [ pkgs.lolcat ];
  }; 

  systemd.services = {
    fatherhood-gateway = {
      description = "Service Fatherhood Gateway";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "fatherhood-registry.service" ];
      requires = [ "fatherhood-registry.service" ];
      serviceConfig = {
        ExecStart = "/etc/fatherhood/gateway";
        Restart = "always";
        RestartSec = "30s";
        EnvironmentFile= "/etc/fatherhood/.env";
      };
    };
    fatherhood-registry = {
      description = "Service Fatherhood Registry";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "/etc/fatherhood/registry";
        Restart = "always";
        RestartSec = "30s";
        EnvironmentFile= "/etc/fatherhood/.env";
      };
    };
    fatherhood-visionary = {
      description = "Service Fatherhood Visionary";
      wantedBy = [ "network-session.target" ];
      after = [ "network-session.target" "fatherhood-registry.service" ];
      requires = [ "fatherhood-registry.service" ];
      serviceConfig = {
        ExecStart = "/etc/fatherhood/visionary";
        Restart = "always";
        RestartSec = "30s";
        EnvironmentFile= "/etc/fatherhood/.env";
      };
    };
    fatherhood-sonify = {
      description = "Service Fatherhood Sonify";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "fatherhood-registry.service" ];
      requires = [ "fatherhood-registry.service" ];
      serviceConfig = {
        ExecStart = "/etc/fatherhood/sonify";
        Restart = "always";
        RestartSec = "30s";
        EnvironmentFile= "/etc/fatherhood/.env";
      };
    };
  };
}
