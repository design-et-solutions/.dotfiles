{ pkgs, ... }: {
  networking= {
    networkmanager = {
      enable = true;
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 8080 ];
      allowedUDPPorts = [ 53 ];
    };
  };

  environment.systemPackages = with pkgs; [
    networkmanager   
    networkmanager-openvpn
    protobuf       
    nmap
  ];
}
