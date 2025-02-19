#!/usr/bin/env fish

if test "$THEME" = "tokyonight-dark"
    set tmux_path (nix-build -E 'let pkgs = import <nixpkgs> {}; tokyonight = pkgs.tmuxPlugins.mkTmuxPlugin { pluginName = "tokyonight"; version = "latest"; src = pkgs.fetchFromGitHub { owner = "fabioluciano"; repo = "tmux-tokyo-night"; rev = "main"; sha256 = "sha256-9nDgiJptXIP+Hn9UY+QFMgoghw4HfTJ5TZq0f9KVOFg="; }; }; in tokyonight')
    $tmux_path/share/tmux-plugins/tokyonight/tmux-tokyo-night.tmux 2&> /dev/null
else if test "$THEME" = "gruvbox-light"
    set tmux_path $(nix eval --raw nixpkgs#tmuxPlugins.gruvbox.outPath)
    $tmux_path/share/tmux-plugins/gruvbox/gruvbox-tpm.tmux 2&> /dev/null
end
