{ 
  pkgs,
  ... 
}:
{
  imports = [
    ../../../modules/nixos/core 
    
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    ../../../modules/nixos/optional/wifi/home 
  ];

  networking.hostName = "laptop-hood";

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.sddm.wayland.enable = true;
  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    wayland
    xwayland
    hyprland
  ];
}