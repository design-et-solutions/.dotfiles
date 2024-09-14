{ pkgs, mergedSetup, ... }:
{
  environment.systemPackages = with pkgs; [
    wayfire
    wf-config
    wf-shell
    wcm
    wlroots
    wayland
    xwayland
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
