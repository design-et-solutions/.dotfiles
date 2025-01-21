{ config, pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    cycle = true;
    pass = { };
    location = "center";
    plugins = with pkgs; [
      rofi-calc
      rofi-emoji
    ];
    extraConfig = {
      hide-scrollbar = true;
      show-icons = true;
    };
    font = "FiraCode Nerd Font 12";
  };

  xdg.configFile."rofi/theme".source = ./theme;

  home.file = {
    ".scripts/rofi/menu_themes.fish" = {
      source = builtins.toString ../../../scripts/rofi/menu_themes.fish;
      executable = true;
    };
    ".scripts/rofi/menu_power.fish" = {
      source = builtins.toString ../../../scripts/rofi/menu_power.fish;
      executable = true;
    };
    ".scripts/rofi/menu_launcher.fish" = {
      source = builtins.toString ../../../scripts/rofi/menu_launcher.fish;
      executable = true;
    };
    ".scripts/rofi/menu_shortcuts.fish" = {
      source = builtins.toString ../../../scripts/rofi/menu_shortcuts.fish;
      executable = true;
    };
  };
}
