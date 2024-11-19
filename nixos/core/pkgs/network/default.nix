{ pkgs, ... }: {
  networking= {
    networkmanager = {
      enable = true;
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 8080 ];
      allowedUDPPorts = [ 53 ];
      denyUnresolved = true;
    };
  };

  environment.systemPackages = with pkgs; [
    networkmanager   
    protobuf       
    nmap
  ];
}
