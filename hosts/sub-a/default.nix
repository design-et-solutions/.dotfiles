{ pkgs, lib, ... }:{
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];
  
  time.timeZone = "Europe/Paris";

  networking= {
    hostName = "sub-a";
  };

  system.services.test = {
    serviceConfig = {
      ExecStart = "echo 'Hello'";
    }
  };
}
