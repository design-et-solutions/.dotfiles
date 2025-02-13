starship init fish | source
fish_vi_key_bindings

if not set -q THEME
    set -xU THEME gruvbox-light
end

fzf --fish | source
