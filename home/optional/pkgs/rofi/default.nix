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
    theme = "~/.config/rofi/theme.rasi";
    extraConfig = {
      hide-scrollbar = true;
      show-icons = true;
    };
    font = "FiraCode 14";
  };

  xdg.configFile = {
    "rofi/theme.rasi".source = ./theme.rasi;
  };
}
