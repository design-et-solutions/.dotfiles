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
    extraConfig = ''
# automatically move window after deleting window
set -g renumber-windows on
    '';
  };

  home.file = {
    ".tmux.conf".source = ./tmux.conf;
  }; 
}
