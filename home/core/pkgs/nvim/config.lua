-- Set completeopt for better completion experience
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Copy/Past Clipboard
vim.opt.clipboard = 'unnamedplus'

-- Treesitter configuration
require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
    },
}    

-- Gruvbox configuration
require("gruvbox").setup({
    terminal_colors = true,
    undercurl = true,
    underline = true,
    bold = true,
    italic = {
        strings = true,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
    },
    strikethrough = true,
    invert_selection = false,
    invert_signs = false,
    invert_tabline = false,
    invert_intend_guides = false,
    inverse = true,
    contrast = "medium",
    palette_overrides = {},
    overrides = {},
    dim_inactive = false,
    transparent_mode = false,
})

-- Set colorscheme
vim.o.background = "light"
vim.cmd("colorscheme gruvbox")

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Enable 24-bit color
vim.opt.termguicolors = true

-- Setup nvim-tree
require("nvim-tree").setup({
    sort = { sorter = "case_sensitive" },
    view = { width = 25 },
    renderer = { group_empty = true },
    filters = { dotfiles = false },
})

require("bufferline").setup{
    options = {
        mode = "buffers",
        numbers = "none",
        close_command = "bdelete! %d",
        right_mouse_command = "bdelete! %d",
        left_mouse_command = "buffer %d",
        middle_mouse_command = nil,
        indicator = {
            -- icon = '▎',
            style = 'icon',
        },
        buffer_close_icon = '',
        modified_icon = '●',
        close_icon = '',
        left_trunc_marker = '',
        right_trunc_marker = '',
        max_name_length = 18,
        max_prefix_length = 15,
        tab_size = 18,
        diagnostics = "nvim_lsp",
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        persist_buffer_sort = true,
        separator_style = "thin",
        enforce_regular_tabs = true,
        always_show_bufferline = true,
    }
}

require("toggleterm").setup{
    open_mapping = [[<c-\>]],
    direction = "float",
    float_opts = {
        winblend = 0,
    },
    highlights = {
        FloatBorder = {
          guifg = colors.fg0,
          guibg = colors.bg0,
        },
        NormalFloat = {
          guibg = colors.bg0,
        },
    },
}
