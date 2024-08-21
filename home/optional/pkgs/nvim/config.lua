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

-- Key mappings for nvim-tree
vim.api.nvim_set_keymap('n', '<A-n>', ':NvimTreeToggle<CR>', { 
    desc = "toggle tree" 
})
vim.api.nvim_set_keymap('n', '<A-t>', ':NvimTreeFocus<CR>', { 
    desc = "focus tree" 
})
vim.api.nvim_set_keymap('n', '<A-r>', ':NvimTreeRefresh<CR>', { 
    desc = "refresh tree" 
})

-- Key mappings for nvim
vim.api.nvim_set_keymap('n', '<A-q>', ':bd<CR>', { 
    desc = "close focused file" 
})
vim.api.nvim_set_keymap('n', '<C-s>', ':w<CR>', { 
    desc = "save focused file" 
})

vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", { 
    desc = "switch window left" 
})
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", { 
    desc = "switch window right" 
})
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", { 
    desc = "switch window down" 
})
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", { 
    desc = "switch window up" 
})

vim.api.nvim_set_keymap("n", "<A>fm", function()
  require("conform").format { lsp_fallback = true }
end, { 
    desc = "general Format file" 
})

-- Comment
vim.api.nvim_set_keymap("n", "<A-/>", "gcc", { 
    desc = "Toggle Comment", 
    remap = true 
})
vim.api.nvim_set_keymap("v", "<A-/>", "gc", { 
    desc = "Toggle comment", 
    remap = true 
})
