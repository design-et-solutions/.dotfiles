{ pkgs, ... }:
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

  home.file.".local/share/rofi/themes/gruvbox.rasi".source = ./gruvbox.rasi;
  home.file.".local/share/rofi/themes/launcher.rasi".source = ./launcher.rasi;
  home.file.".local/share/rofi/themes/powermenu.rasi".source = ./powermenu.rasi;
}
