{ pkgs, lib, ... }:{
  imports = [
    # Import general core 
    ../../nixos/core 

    # Import optional
    ../../nixos/optional/drivers/gpu/nvidia
    ../../nixos/optional/drivers/audio
    ../../nixos/optional/wayland 
    ../../nixos/optional/window-manager/hyprland 
  ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };
}
