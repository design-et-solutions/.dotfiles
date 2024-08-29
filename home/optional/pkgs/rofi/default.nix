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
    theme = ./theme.rasi;
    extraConfig = {
      hide-scrollbar = true;
      show-icons = true;
    };
    font = "FiraCode Nerd Font 14";
  };

  home.file.".local/share/rofi/themes/guvbox.rasi".source = ./guvbox.rasi;
}
