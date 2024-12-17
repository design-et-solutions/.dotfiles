{ config, ... }: 
let
  # homeDir = builtins.getEnv "HOME";
  homeDir = config.home.homeDirectory;
in {
    # https://www.mankier.com/5/mako
    services.mako = {
        enable = true;
        # null or one of "top-right", "top-center", "top-left", "bottom-right", "bottom-center", "bottom-left", "center"
        anchor = "bottom-right";
        backgroundColor = "#fbf1c7";
        borderColor = "#3c3836";
        textColor = "#3c3836";
        progressColor = "over #5588AA";
        borderRadius = 0;
        borderSize = 4;
        font = "FiraCode Nerd Font Mono 10";
        format = "<b>%s</b>\\n%b";
        groupBy = null;
        height = 100;
        width = 300;
        margin = "5, 0";
        padding = "5";
        iconPath = "${homeDir}/.icons/light";
        icons = true;
        ignoreTimeout = false;
        # null or one of "background", "bottom", "top", "overlay"
        layer = "top";
        # If 1, enable Pango markup. If 0, disable Pango markup. If enabled, Pango markup will be interpreted in your format specifier and in the body of notifications.
        markup = true;
        maxIconSize = 64;
        maxVisible = 5;
        output = null;
        # null or one of "+time", "-time", "+priority", "-priority"
        sort = "-time";
        defaultTimeout = 5000;
        extraConfig = ''
          outer-margin=20

          [urgency=low]
          border-color=#458588

          [urgency=critical]
          border-color=#cc241d
          default-timeout=0

          [category=info]
          text-color=#0000ff
        '';
  };
}
