{ pkgs, lib, ... }:{
  environment.systemPackages = with pkgs; [
    obs-studio
    wireplumber
    xdg-desktop-portal
    xdg-desktop-portal-hyprland
    xwaylandvideobridge
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };
}
