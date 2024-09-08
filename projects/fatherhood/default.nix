{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.fatherhood;
in {
  options.services.fatherhood = {
    enable = mkEnableOption "Fatherhood service";
    user = mkOption {
      type = types.str;
      default = "me";
      description = "User to run the Fatherhood service";
    };
  };

  config = mkIf cfg.enable {
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
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" "fatherhood-registry.service" ];
        requires = [ "fatherhood-registry.service" ];
        environment = {
          DISPLAY = ":0";
          WAYLAND_DISPLAY = "wayland-1";
          XDG_RUNTIME_DIR = "/run/user/" + cfg.user;
        };
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
        environment = {
          XDG_RUNTIME_DIR = "/run/user/"+ cfg.user;
          PULSE_SERVER = "/run/user/"+ cfg.user +"/pulse/native";
        };
        serviceConfig = {
          User = cfg.user;
          Group = "audio";
          ExecStart = "/etc/fatherhood/sonify";
          Restart = "always";
          RestartSec = "30s";
          EnvironmentFile= "/etc/fatherhood/.env";
        };
      };
    };
  };
}
