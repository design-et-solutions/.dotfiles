{ ... }:
{
  xdg.configFile = {
    "hypr/hyprland.conf".source = ../../../custom/hypr/hyprland.conf;
    "hypr/windowrule.conf".source = ../../../custom/hypr/windowrule.conf;
    "hypr/keybinds.conf".source = ../../../custom/hypr/keybinds.conf;
    "hypr/scripts".source = ../../../custom/hypr/scripts;
    "hypr/scripts/wallpapers-randomizer.sh".executable = true;

    "kitty/kitty.conf".source = ../../../custom/kitty/kitty.conf;

    "hypr/hyprpaper.conf".source = ../../../custom/hyprpaper/hyprpaper.conf;
  };

  home.file = {
    ".wallpapers".source = ../../../custom/wallpapers;
  };
}
