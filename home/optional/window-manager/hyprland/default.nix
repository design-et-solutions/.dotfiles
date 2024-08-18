{ pkgs, ... }: {
  imports = [
    ../../pkgs/kitty 
    ../../pkgs/rofi 
    ../../pkgs/yazi 
    ../../pkgs/waybar 
  ];

  xdg.configFile = {
    "hypr/hyprland.conf".source = ../../../custom/hypr/hyprland.conf;
    "hypr/windowrule.conf".source = ../../../custom/hypr/windowrule.conf;
    "hypr/keybinds.conf".source = ../../../custom/hypr/keybinds.conf;

    "hypr/hyprpaper.conf".source = ../../../custom/hyprpaper/hyprpaper.conf;
  };

  home.file = {
    ".wallpapers".source = ../../../custom/wallpapers;
    ".scripts/wallpapers-randomizer.sh" = {
      source = ../../../custom/scripts/wallpapers-randomizer.sh;
      executable = true;
    };
  };

  home.packages = with pkgs; [ 
    hyprpaper
  ];
}
