{ pkgs, lib, ... }:{
  imports = [
    # Import general core 
    ../../nixos/core 

    # Import optional
  ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };
}
