{ pkgs, ... }: let 
  tokyonight = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tokyonight";
    version = "latest";
    src = pkgs.fetchFromGitHub {
      owner = "fabioluciano";
      repo = "tmux-tokyo-night";
      rev = "main";
      sha256 = "sha256-9nDgiJptXIP+Hn9UY+QFMgoghw4HfTJ5TZq0f9KVOFg=";
    };
  };
in {
  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
    newSession = true;
    mouse = true;
    plugins = with pkgs.tmuxPlugins; [
      # https://github.com/tmux-plugins/tmux-cpu
      cpu
      # https://github.com/tmux-plugins/tmux-resurrect
      {
        plugin = resurrect;
        # extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      # https://github.com/tmux-plugins/tmux-continuum
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '20'
        '';
      }
      # https://github.com/laktak/extrakto
      extrakto
      # https://github.com/tmux-plugins/tmux-fpp
      fpp
      # https://github.com/roosta/tmux-fuzzback
      fuzzback
      # https://github.com/tmux-plugins/tmux-sidebar
      sidebar
      # https://github.com/alexwforsythe/tmux-which-key
      # tmux-which-key
      # https://github.com/fabioluciano/tmux-tokyo-night
      tokyonight
      # https://github.com/egel/tmux-gruvbox
      gruvbox
    ];
    prefix = "C-f";
    keyMode = "vi";
    baseIndex = 1;
    extraConfig = ''
      ${builtins.readFile ./config.conf}
      ${builtins.readFile ./keybindings.conf}
    '';
  };

  home.file.".scripts/tmux_reloader.fish" = {
      source = builtins.toString ../../../scripts/tmux_reloader.fish;
      executable = true;
  };
}
