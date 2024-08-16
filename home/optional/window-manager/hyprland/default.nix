{ ... }:
{
  xdg.configFile = {
    "hypr/hyprland.conf".source = ../../../custom/hypr/hyprland.conf;
    "hypr/windowrule.conf".source = ../../../custom/hypr/windowrule.conf;
    "hypr/keybinds.conf".source = ../../../custom/hypr/keybinds.conf;

    "kitty/kitty.conf".source = ../../../custom/kitty/kitty.conf;

    "hypr/hyprpaper.conf".source = ../../../custom/hyprpaper/hyprpaper.conf;

    "rofi/config.rasi".source = ../../../custom/rofi/config.rasi;
  };

  home.file = {
    ".wallpapers".source = ../../../custom/wallpapers;
    ".scripts/wallpapers-randomizer.sh" = {
      source = ../../../custom/scripts/wallpapers-randomizer.sh;
      executable = true;
    };
  }; 
}
