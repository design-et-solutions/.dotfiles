{ pkgs, ... }:
{
  services.xserver = {
    enable = true;
    displayManager.gdm = {
        enable = true;
        wayland = true;
    };
  };

  services.ratbagd.enable = true;

  environment.systemPackages = with pkgs; [
    swaylock # screen locker
    swayidle # screen idle management
    waybar # screen bar
  ];
}
