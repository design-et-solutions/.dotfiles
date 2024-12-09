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
      {
        plugin = pkgs.tmuxPlugins.mkTmuxPlugin {
          pluginName = "tmux-tokyo-night";
          version = "1.9.0";
          src = pkgs.fetchFromGitHub {
            owner = "fabioluciano";
            repo = "tmux-tokyo-night";
            rev = "main";
            sha256 = "sha256-9nDgiJptXIP+Hn9UY+QFMgoghw4HfTJ5TZq0f9KVOFg=";
          };
          postInstall = ''
            mv $out/share/tmux-plugins/tmux-tokyo-night/tmux-tokyo-night.tmux $out/share/tmux-plugins/tmux-tokyo-night/tmux_tokyo_night.tmux
          '';
        };
        extraConfig = ''
          set -g @theme_variation 'night'
        '';
      }
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
