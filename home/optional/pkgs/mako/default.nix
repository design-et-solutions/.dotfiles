{ config, ... }: 
let
  # homeDir = builtins.getEnv "HOME";
  homeDir = config.home.homeDirectory;
in {
  # https://www.mankier.com/5/mako
  services.mako = {
    enable = true;
  };

  xdg.configFile."mako/theme".source = ./theme;
}
