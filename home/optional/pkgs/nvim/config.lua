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

-- Key mappings 

-- Tree
vim.keymap.set('n', '<A-n>', ':NvimTreeToggle<CR>', { 
    desc = "toggle tree" 
})
vim.keymap.set('n', '<A-t>', ':NvimTreeFocus<CR>', { 
    desc = "focus tree" 
})
vim.keymap.set('n', '<A-r>', ':NvimTreeRefresh<CR>', { 
    desc = "refresh tree" 
})

-- Mouvement
vim.keymap.set("n", "<C-h>", "<C-w>h", { 
    desc = "switch window left" 
})
vim.keymap.set("n", "<C-l>", "<C-w>l", { 
    desc = "switch window right" 
})
vim.keymap.set("n", "<C-j>", "<C-w>j", { 
    desc = "switch window down" 
})
vim.keymap.set("n", "<C-k>", "<C-w>k", { 
    desc = "switch window up" 
})

-- Format File
vim.keymap.set("n", "<A-m>", function()
  require("conform").format { lsp_fallback = true }
end, { 
    desc = "general Format file" 
})

-- Comment
vim.keymap.set("n", "<A-c>", "gcc", { 
    desc = "Toggle Comment", 
    remap = true 
})
vim.keymap.set("v", "<A-c>", "gc", { 
    desc = "Toggle comment", 
    remap = true 
})

-- Buff
vim.keymap.set('n', '<A-q>', ':bd<CR>', { 
    desc = "close focused file" 
})
vim.keymap.set('n', '<C-s>', ':w<CR>', { 
    desc = "save focused file" 
})
vim.keymap.set('n', '<Tab>', ':bnext<CR>', { 
    desc = "move to the next buffer" 
})
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', { 
    desc = "move to the previous buffer" 
})
vim.keymap.set('n', '<A-b>', ':buffers<CR>', { 
    desc = "list buffers" 
})

-- Split Window
vim.keymap.set('n', '<A-h>', ':split<CR>', { 
    desc = "split window horizontally" 
})
vim.keymap.set('n', '<A-v>', ':vsplit<CR>', { 
    desc = "split window vertically" 
})

