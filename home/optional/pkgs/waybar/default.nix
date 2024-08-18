{ ... }: {
  programs.waybar = {
    enable = true;
    style = "~/.config/waybar/waybar.css";
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
    "waybar/waybar.css".source = ../../../custom/waybar/waybar.css;
  };
}
