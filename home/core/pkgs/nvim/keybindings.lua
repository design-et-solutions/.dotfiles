vim.g.mapleader = " "
-- =============================== 
-- focus
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true, desc = "switch window left" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true, desc = "switch window right" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true, desc = "switch window down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true, desc = "switch window up" })

-- =============================== 
-- tree
vim.keymap.set('n', '<leader>n', ':NvimTreeToggle<CR>', { noremap = true, silent = true, desc = "toggle tree" })
vim.keymap.set('n', '<leader>t', ':NvimTreeFocus<CR>', { noremap = true, silent = true, desc = "focus tree" })
vim.keymap.set('n', '<leader>r', ':NvimTreeRefresh<CR>', { noremap = true, silent = true, desc = "refresh tree" })

-- =============================== 
-- format File
vim.keymap.set("n", "<leader>m", function()
  require("conform").format { lsp_fallback = true }
end, { noremap = true, silent = true, desc = "general Format file" })

-- =============================== 
-- comment
vim.keymap.set("n", "<leader>c", "gcc", { remap = true, silent = true, desc = "Toggle Comment" })
vim.keymap.set("v", "<leader>c", "gc", { remap = true, silent = true, desc = "Toggle comment" })

-- =============================== 
-- buffer
vim.keymap.set('n', '<C-x>', ':bp | bd #<CR>', { noremap = true, silent = true, desc = "close buffer" })
vim.keymap.set('n', '<C-s>', ':w<CR>', { noremap = true, silent = true, desc = "save buffer" })
vim.keymap.set('n', '<Tab>', ':bnext<CR>', { noremap = true, silent = true, desc = "move to the next buffer" })
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', { noremap = true, silent = true, desc = "move to the previous buffer" })
vim.keymap.set('n', '<leader>b', ':buffers<CR>', { noremap = true, silent = true, desc = "list buffers" })

-- =============================== 
-- split window
vim.keymap.set('n', '<leader>sh', ':split<CR>', { noremap = true, silent = true, desc = "split window horizontally" })
vim.keymap.set('n', '<leader>sv', ':vsplit<CR>', { noremap = true, silent = true, desc = "split window vertically" })
