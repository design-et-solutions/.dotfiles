{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # wayland.windowManager.hyprland = {
  #   enable = true;
  #   systemd.enable = true;
  #   extraConfig = ''
  #     monitor=,preferred,auto,auto
  #
  #     # Set programs that you use
  #     $terminal = kitty
  #     $menu = wofi --show drun
  #
  #     # Some default env vars.
  #     env = XCURSOR_SIZE,24
  #
  #     # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
  #     input {
  #         kb_layout = us
  #         kb_variant =
  #         kb_model =
  #         kb_options =
  #         kb_rules =
  #
  #         follow_mouse = 1
  #
  #         touchpad {
  #             natural_scroll = no
  #         }
  #
  #         sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
  #     }
  #
  #     general {
  #         gaps_in = 5
  #         gaps_out = 20
  #         border_size = 2
  #         col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
  #         col.inactive_border = rgba(595959aa)
  #
  #         layout = dwindle
  #     }
  #
  #     decoration {
  #         rounding = 10
  #     }
  #
  #     animations {
  #         enabled = yes
  #
  #         bezier = myBezier, 0.05, 0.9, 0.1, 1.05
  #
  #         animation = windows, 1, 7, myBezier
  #         animation = windowsOut, 1, 7, default, popin 80%
  #         animation = border, 1, 10, default
  #         animation = fade, 1, 7, default
  #         animation = workspaces, 1, 6, default
  #     }
  #
  #     dwindle {
  #         pseudotile = yes # master switch for pseudotiling
  #         preserve_split = yes # you probably want this
  #     }
  #
  #     master {
  #         new_is_master = true
  #     }
  #
  #     gestures {
  #         workspace_swipe = off
  #     }
  #
  #     # Example keybinds
  #     bind = SUPER, Q, exec, $terminal
  #     bind = SUPER, C, killactive, 
  #     bind = SUPER, M, exit, 
  #     bind = SUPER, E, exec, $fileManager
  #     bind = SUPER, V, togglefloating, 
  #     bind = SUPER, R, exec, $menu
  #     bind = SUPER, P, pseudo, # dwindle
  #     bind = SUPER, J, togglesplit, # dwindle
  #   '';
  # };
  #
  # environment.systemPackages = with pkgs; [
  #   kitty  # terminal
  #   wofi   # application launcher
  # ];
}
