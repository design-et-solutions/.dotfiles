{ pkgs, lib, ... }:{
  imports = [
    # Import general core 
    ../default.nix
    
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    # Import optional
    ../../../nixos/optional/drivers/gpu/intel
    ../../../nixos/optional/pkgs/python
    ../../../nixos/optional/pkgs/steam
  ];
  
  time.timeZone = "Europe/Paris";

  networking= {
    hostName = "desktop-work";
    firewall.allowedTCPPorts = lib.mkAfter [ 5000 ];
  };

  environment.systemPackages = with pkgs; [
    steam-run # Steam env like
  ];

  services.displayManager.autoLogin = {
    enable = true;
    user = "me";
  };

  # custom
  systemd.services.unity = {
    description = "Service Unity";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.steam-run}/bin/steam-run /home/guest/build.x86_64";
    };
  };
}
