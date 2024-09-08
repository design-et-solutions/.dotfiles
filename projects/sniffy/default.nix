{ lib, pkgs, ... }:{
  networking= {
    firewall.allowedTCPPorts = lib.mkAfter [ 4000 ];
  };

  # dependency
  environment = {
    etc = {
      "sniffy/build".source = ./build;
      "sniffy/package.json".source = ./package.json;
      "sniffy/yarn.lock".source = ./yarn.lock;
    };
    systemPackages = with pkgs; [
      nodePackages.serve
    ];
  }; 

  systemd.services = {
    sniffy = {
      description = "Service Sniffy";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "fatherhood-gateway.service" ];
      requires = [ "fatherhood-gateway.service" ];
      environment = {
        PORT = "4000";
      };
      serviceConfig = {
        WorkingDirectory = "/etc/sniffy";
        ExecStart = "${pkgs.nodePackages.serve}/bin/serve -s build";
        Restart = "always";
        RestartSec = "30s";
      };
    };
  };
}
