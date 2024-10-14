{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
    mouse = true;
    plugins = with pkgs.tmuxPlugins; [
      cpu
      {
        plugin = resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '60' # minutes
        '';
      }
      gruvbox
      tokyo-night-tmux
    ];
    prefix = "C-f";
    keyMode = "vi";
    baseIndex = 1;
    extraConfig = ''
      ${builtins.readFile ./config.conf}
      ${builtins.readFile ./keybindings.conf}
    '';
  };
}
