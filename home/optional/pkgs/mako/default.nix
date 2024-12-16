{ ... }: {
    # https://www.mankier.com/5/mako
    services.mako = {
        enable = true;
        # null or one of "top-right", "top-center", "top-left", "bottom-right", "bottom-center", "bottom-left", "center"
        anchor = "bottom-right";
        backgroundColor = "#1c0f13";
        borderColor = "#5762D5";
        textColor = "#BBBAC6";
        progressColor = "over #5588AAFF";
        borderRadius = 0;
        borderSize = 4;
        font = "FiraCode Nerd Font Mono 10";
        format = "<b>%s</b>\\n%b";
        groupBy = null;
        height = 100;
        width = 300;
        margin = "0";
        padding = "10";
        iconPath = null;
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
          [urgency=low]
          border-color=#b8bb26
        '';
  };
}
