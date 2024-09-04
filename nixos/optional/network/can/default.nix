{ pkgs, lib, config, ... }:

with lib;

let
  cfg = config.networking.can;
in {
  options.networking.can = {
    interfaces = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          bitrate = mkOption {
            type = types.int;
            default = 500000;
            description = "The bitrate for the CAN interface.";
          };
          txqueuelen = mkOption {
            type = types.int;
            default = 1000;
            description = "The transmission queue length for the CAN interface.";
          };
        };
      });
      default = {};
      description = "CAN interfaces to configure.";
    };
  };

  config = mkIf (cfg.interfaces != {}) {
    environment.systemPackages = with pkgs; [
      can-utils
    ];

    systemd.services = mapAttrs (name: interface: {
      description = "Setup ${name} CAN interface";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.iproute2}/bin/ip link set ${name} type can bitrate ${toString interface.bitrate} txqueuelen ${toString interface.txqueuelen} && ${pkgs.iproute2}/bin/ip link set ${name} up'";
        ExecStop = "${pkgs.iproute2}/bin/ip link set ${name} down";
      };
    }) cfg.interfaces;
  };
}
