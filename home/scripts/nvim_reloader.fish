#!/usr/bin/env fish

if test "$THEME" = tokyonight-dark
    for server_name in $XDG_RUNTIME_DIR/nvim.* # maybe should be updated later lol
        nvim --server "$server_name" --remote-send ":lua vim.o.background = 'dark'<CR>"
        nvim --server "$server_name" --remote-send ":lua vim.cmd('colorscheme tokyonight-night')<CR>"
    end
else if test "$THEME" = gruvbox-light
    for server_name in $XDG_RUNTIME_DIR/nvim.* # maybe should be updated later lol
        nvim --server "$server_name" --remote-send ":lua vim.o.background = 'light'<CR>"
        nvim --server "$server_name" --remote-send ":lua vim.cmd('colorscheme gruvbox')<CR>"
        # double to avoid color issue
        nvim --server "$server_name" --remote-send ":lua vim.cmd('colorscheme gruvbox')<CR>"
    end
end
