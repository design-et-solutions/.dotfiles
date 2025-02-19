{ config, pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    cycle = true;
    location = "center";
    pass = { };
    plugins = [
      pkgs.rofi-calc
      pkgs.rofi-emoji
      pkgs.rofi-systemd
    ];
    extraConfig = {
      hide-scrollbar = true;
      show-icons = true;
    };
    font = "FiraCode Nerd Font 14";
  };

  home.file = {
    ".local/share/rofi/themes/launcher.rasi" = {
      source = ./launcher.rasi;
      force = true;
    };
    ".local/share/rofi/themes/powermenu.rasi" = {
      source = ./powermenu.rasi;
      force = true;
    };
    ".local/share/rofi/themes/themesmenu.rasi" = {
      source = ./themesmenu.rasi;
      force = true;
    };
    ".local/share/rofi/themes/dark-theme.rasi" = {
      source = ./dark-theme.rasi;
      force = true;
    };
    ".local/share/rofi/themes/light-theme.rasi" = {
      source = ./light-theme.rasi;
      force = true;
    };
    ".scripts/themesmenu.sh" = {
      source = builtins.toString ../../../scripts/themesmenu.sh;
      force = true;
      executable = true;
    };
    ".scripts/powermenu.sh" = {
      source = builtins.toString ../../../scripts/powermenu.sh;
      force = true;
      executable = true;
    };
  };
}
