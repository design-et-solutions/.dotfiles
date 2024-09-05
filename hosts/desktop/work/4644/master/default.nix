{ pkgs, lib, ... }:{
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    # Import optional
    ../../../../../nixos/optional/drivers/gpu/intel
  ];

  time.timeZone = "Europe/Paris";
  
  networking= {
    hostName = "desktop-work-4644-master";
    firewall.allowedTCPPorts = lib.mkAfter [ 3000 ];
  };

  services.displayManager.autoLogin = {
    enable = true;
    user = "guest";
  };

  environment.systemPackages = with pkgs; [
    nodejs_22
  ];

  # systemd.services.cantrolly = {
  #   description = "Service CAN manager";
  #   wantedBy = [ "multi-user.target" ];
  #   after = [ "network.target" ];
  #   serviceConfig = {
  #     ExecStart = "/home/guest/cantrolly";
  #     Restart = "always";
  #     RestartSec = "30s";
  #   };
  # };

  # systemd.services.web-front = {
  #   description = "Service Web Front";
  #   wantedBy = [ "multi-user.target" ];
  #   after = [ "network.target" ];
  #   serviceConfig = {
  #     ExecStart = "npm run /home/guest/build.x86_64";
  #     Restart = "always";
  #     RestartSec = "30s";
  #   };
  # };
}
