{ ... }:{
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
    fatherhood-cantrolly = {
      description = "Service Fatherhood Cantrolly";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "fatherhood-registry.service" ];
      requires = [ "fatherhood-registry.service" ];
      serviceConfig = {
        ExecStart = "/etc/fatherhood/cantrolly";
        Restart = "always";
        RestartSec = "30s";
        EnvironmentFile= "/etc/fatherhood/.env";
      };
    };
    fatherhood-visionary = {
      description = "Service Fatherhood Visionary";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "fatherhood-registry.service" ];
      requires = [ "fatherhood-registry.service" ];
      environment = {
        WAYLAND_DISPLAY = "wayland-1";
        XDG_RUNTIME_DIR = "/run/user/1001";
      };
      serviceConfig = {
        ExecStart = "/etc/fatherhood/visionary";
        Restart = "always";
        RestartSec = "30s";
        EnvironmentFile= "/etc/fatherhood/.env";
      };
    };
  };
}
