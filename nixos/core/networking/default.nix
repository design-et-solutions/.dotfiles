{ pkgs, ... }: {
  # https://search.nixos.org/options?channel=24.11&query=networking
  networking= {
    networkmanager = {
      enable = true;
    };
    # https://search.nixos.org/options?query=networking.firewall
    firewall = {
      enable = true;
      logRefusedConnections = true;
      allowedTCPPorts = [ 80 443 8080 ];
      allowedUDPPorts = [ 53 ];
    };
  };  

  systemd.services.NetworkManager.serviceConfig = {
    # ProtectSystem = "strict";
    ProtectTmp = true;
    NoNewPrivileges = true;
    PrivateDevices = true;
    DevicePolicy= "closed";
    ProtectKernelModules = true; 
    ProtectKernelTunables = true;
  };

  systemd.services.NetworkManager-dispatcher.serviceConfig = {
    ProtectSystem = "strict";
    ProtectTmp = true;
    NoNewPrivileges = true;
    PrivateDevices = true;
    DevicePolicy= "closed";
    ProtectKernelModules = true; 
    ProtectKernelTunables = true;
  };

  systemd.services.wpa_supplicant.serviceConfig = {
    ProtectSystem = "strict";
    ProtectHome = true;
    PrivateTmp = true;
    NoNewPrivileges = true;
    PrivateDevices = true;
    DevicePolicy= "closed";
    ProtectKernelModules = true; 
    ProtectKernelTunables = true;
  };

  environment.systemPackages = with pkgs; [
    networkmanager   
    protobuf       
    nmap
    wget
    websocat
    curl
  ];
}
