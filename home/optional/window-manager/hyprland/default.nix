{ pkgs, ... }: {
  imports = [
    ../../pkgs/kitty 
    ../../pkgs/rofi 
    ../../pkgs/yazi 
    ../../pkgs/waybar 
  ];

  xdg.configFile = {
    "hypr/hyprland.conf".source = ./hyprland.conf;
    "hypr/windowrule.conf".source = ./windowrule.conf;
    "hypr/keybinds.conf".source = ./keybinds.conf;
    "hypr/hyprpaper.conf".source = ./hyprpaper.conf;
  };

  home.file = {
    ".wallpapers".source = ../../../wallpapers;
    ".scripts/wallpapers-randomizer.sh" = {
      source = ../../../scripts/wallpapers-randomizer.sh;
      executable = true;
    };
  };

  home.packages = with pkgs; [ 
    hyprpaper
  ];
}
