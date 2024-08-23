-- =============================== 
-- focus
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

-- =============================== 
-- tree
vim.keymap.set('n', '<A-n>', ':NvimTreeToggle<CR>', { 
    desc = "toggle tree" 
})
vim.keymap.set('n', '<A-t>', ':NvimTreeFocus<CR>', { 
    desc = "focus tree" 
})
vim.keymap.set('n', '<A-r>', ':NvimTreeRefresh<CR>', { 
    desc = "refresh tree" 
})

-- =============================== 
-- format File
vim.keymap.set("n", "<A-m>", function()
  require("conform").format { lsp_fallback = true }
end, { 
    desc = "general Format file" 
})

-- =============================== 
-- comment
vim.keymap.set("n", "<A-c>", "gcc", { 
    desc = "Toggle Comment", 
    remap = true 
})
vim.keymap.set("v", "<A-c>", "gc", { 
    desc = "Toggle comment", 
    remap = true 
})

-- =============================== 
-- buffer
vim.keymap.set('n', '<A-q>', ':bd<CR>', { 
    desc = "close buffer" 
})
vim.keymap.set('n', '<C-s>', ':w<CR>', { 
    desc = "save buffer" 
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

-- =============================== 
-- split window
vim.keymap.set('n', '<A-h>', ':split<CR>', { 
    desc = "split window horizontally" 
})
vim.keymap.set('n', '<A-v>', ':vsplit<CR>', { 
    desc = "split window vertically" 
})
