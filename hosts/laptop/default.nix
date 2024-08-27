{ pkgs, lib, ... }:{
  imports = [
    # Import optional
    ../../nixos/optional/drivers/gpu/nvidia
    ../../nixos/optional/drivers/audio
  ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };
}
