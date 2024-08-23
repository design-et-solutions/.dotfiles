{ pkgs, ... }:
{
  services.xserver = {
    enable = true;
    displayManager.gdm = {
        enable = true;
        wayland = true;
    };
  };
  services.libinput = {
    enable = true;
    mouse = {
      accelProfile = "flat";
      accelSpeed = "0";
    };
  };

  environment.systemPackages = with pkgs; [
    swaylock # screen locker
    swayidle # screen idle management
    waybar # screen bar
  ];
}
