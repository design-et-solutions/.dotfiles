{ config, ... }:
let
  homeDir = config.home.homeDirectory;
in
{
  # https://www.mankier.com/5/mako
  services.mako = {
    enable = true;
  };

  xdg.configFile."mako/theme".source = ./theme;

  home.file = {
    ".scripts/mako_reloader.fish" = {
      source = builtins.toString ../../../scripts/mako_reloader.fish;
      executable = true;
    };
  };
}
