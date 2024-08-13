{ ... }:
{
  xdg.configFile = {
    "hypr/hyprland.conf".source = ../../../custom/hypr/hyprland.conf;
    "hypr/windowrule.conf".source = ../../../custom/hypr/windowrule.conf;
    "hypr/keybinds.conf".source = ../../../custom/hypr/keybinds.conf;
    "hypr/env.conf".source = ../../../custom/hypr/env.conf;

    "wezterm/wezterm.lua".source = ../../../custom/wezterm/wezterm.lua;
    "wezterm/lua".source = ../../../custom/wezterm/lua;
    "wezterm/colors".source = ../../../custom/wezterm/colors;
  };
}
