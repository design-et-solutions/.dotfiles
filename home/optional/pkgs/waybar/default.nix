{ ... }: {
  programs.waybar = {
    enable = true;
    style = "~/.config/waybar/style.css";
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [ "workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [ "network" "battery" "pulseaudio" ];
      };
    };
  };

  xdg.configFile = {
    "waybar/style.css".source = ../../../custom/waybar/style.css;
  };
}
