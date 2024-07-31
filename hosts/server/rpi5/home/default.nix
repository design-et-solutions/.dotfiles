{ config, lib, pkgs, ... }:
{
  imports = [
    ../../modules/common/users/root
    ../../modules/nixos/core
  ];

  networking.hostName = "server-home";
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };
  networking.firewall.allowedTCPPorts = [ 
        22 # SHH
        80 # HTTP
        443 # HTTPS
    ];
}