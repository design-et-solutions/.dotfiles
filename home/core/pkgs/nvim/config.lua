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
    sort = { 
        sorter = "case_sensitive" 
    },
    view = { 
        width = 20 
    },
    renderer = { 
        group_empty = true 
    },
    filters = { 
        dotfiles = false 
    },
})
