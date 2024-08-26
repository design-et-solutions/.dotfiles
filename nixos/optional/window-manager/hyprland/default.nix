{ pkgs, ... }:
{
  imports = [
    ../../pkgs/thunar 
  ];

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
}
