{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    shell = "\${pkgs.fish}/bin/fish";
    mouse = true;
    plugins = with pkgs; [
      tmuxPlugins.cpu
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '60' # minutes
        '';
      }
    ];
    prefix = "C-f";
    keyMode = "vi";
    baseIndex = 1;
  };

  # home.file = {
  #   ".tmux.conf".source = ../../../custom/tmux/.tmux.conf;
  #   ".tmux/".source = ../../../custom/tmux/plugins;
  # }; 
}
# # split panes using | and -
# bind _ split-window -h
# bind - split-window -v
# unbind '"'
# unbind %
#
# # switch panes using Alt-arrow without prefix
# bind -n M-Left select-pane -L
# bind -n M-Right select-pane -R
# bind -n M-Up select-pane -U
# bind -n M-Down select-pane -D
#
# # automatically move window after deleting window
# set -g renumber-windows on
#
# # Keeping Current Path 
# bind c new-window -c "#{pane_current_path}"
#
# # Toggle between the current and previous window
# bind a last-window
#
# # Resizing
# bind -r C-j resize-pane -D 15
# bind -r C-k resize-pane -U 15
# bind -r C-h resize-pane -L 15
# bind -r C-l resize-pane -R 15
#
# # Joining Panes
# bind j choose-window 'join-pane -h -s "%%"'
# bind J choose-window 'join-pane -s "%%"'
#
# # List of plugins
# set -g @plugin 'tmux-plugins/tmux-sensible'
# set -g @plugin "arcticicestudio/nord-tmux"
# set -g @plugin 'casonadams/tmux-vi-navigation
#
# # Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
# run '~/.tmux/plugins/tpm/tpm⏎                                                                                                         
