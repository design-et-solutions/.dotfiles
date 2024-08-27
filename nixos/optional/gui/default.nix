{ pkgs, ... }:
{
  imports = [
    ../pkgs/thunar 
    ../pkgs/kitty 
    ../pkgs/rofi 
    ../pkgs/waybar 
    ../pkgs/firefox
    ../pkgs/mpv
  ];

  services = { 
    xserver = {
      enable = true;
      displayManager = {
        gdm = {
          enable = true;
          wayland = true;
        };
      };
    };
    ratbagd.enable = true; # DBus daemon to configure input devices
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.configFile = {
    "hypr/hyprland.conf".source = ./hyprland.conf;
    "hypr/windowrule.conf".source = ./windowrule.conf;
    "hypr/keybindings.conf".source = ./keybindings.conf;
    "hypr/hyprpaper.conf".source = ./hyprpaper.conf;
  };
}
