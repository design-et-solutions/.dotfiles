{ pkgs, lib, ... }:{
  imports = [
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
