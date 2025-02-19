{ pkgs, mergedSetup, ... }:
{
  environment.systemPackages = with pkgs; [
    wayfire # Wayland compositor
    wf-config # Configuration library for Wayfire
    wl-clipboard # Command-line clipboard utilities for Wayland
    wayfirePlugins.wcm # Wayfire Config Manager - GUI configuration tool
    wlroots # A modular Wayland compositor library
    wayland # Core Wayland protocol libraries
    xwayland # X server running as a Wayland client
    wlr-randr # Command line utility to manage outputs of a Wayland compositor
    kooha # Simple screen recorder for Wayland and X11
    swappy # A Wayland native snapshot editing tool
    grim # Screenshot utility for Wayland compositors
    slurp # Select a region in Wayland compositors
  ];

  programs.wayfire.enable = true;

  environment.etc."wayfire.ini".text = ''
    [core]
    plugins = alpha animate autostart command cube decoration expo fast-switcher fisheye grid idle invert move oswitch place resize switcher vswitch window-rules wobbly zoom
    close_top_view = <super> KEY_Q | <alt> KEY_F4
    vwidth = 3
    vheight = 3
  '';
}
