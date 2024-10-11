vim.g.mapleader = " " -- =============================== 
-- focus
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true, desc = "Switch window left" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true, desc = "Switch window right" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true, desc = "Switch window down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true, desc = "Switch window up" })

-- =============================== 
-- tree
vim.keymap.set('n', '<leader>tt', ':NvimTreeToggle<CR>', { noremap = true, silent = true, desc = "Toggle tree" })
vim.keymap.set('n', '<leader>tf', ':NvimTreeFocus<CR>', { noremap = true, silent = true, desc = "Focus tree" })
vim.keymap.set('n', '<leader>tr', ':NvimTreeRefresh<CR>', { noremap = true, silent = true, desc = "Refresh tree" })

-- =============================== 
-- format File
vim.keymap.set("n", "<leader>f", function()
  require("conform").format { lsp_fallback = true }
end, { noremap = true, silent = true, desc = "General Format file" })

-- =============================== 
-- comment
vim.keymap.set("n", "<leader>c", "gcc", { remap = true, silent = true, desc = "Toggle Comment" })
vim.keymap.set("v", "<leader>c", "gc", { remap = true, silent = true, desc = "Toggle comment" })

-- =============================== 
-- buffer
vim.keymap.set('n', '<leader>bc', ':bp | bd #<CR>', { noremap = true, silent = true, desc = "Close buffer" })
vim.keymap.set('n', '<C-s>', ':w<CR>', { noremap = true, silent = true, desc = "Save buffer" })
vim.keymap.set('n', '<Tab>', ':bnext<CR>', { noremap = true, silent = true, desc = "Move to the next buffer" })
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', { noremap = true, silent = true, desc = "Move to the previous buffer" })
vim.keymap.set('n', '<leader>bl', ':buffers<CR>', { noremap = true, silent = true, desc = "List buffers" })

-- =============================== 
-- split window
vim.keymap.set('n', '<leader>sh', ':split<CR>', { noremap = true, silent = true, desc = "Split window horizontally" })
vim.keymap.set('n', '<leader>sv', ':vsplit<CR>', { noremap = true, silent = true, desc = "Split window vertically" })

-- =============================== 
-- telescope
vim.api.nvim_set_keymap("n", "<leader>Tt", ":ToggleTerm direction=float<CR>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("t", "<leader>Tt", "<C-\\><C-n>:ToggleTerm<CR>", {noremap = true, silent = true})

-- =============================== 
-- coc
-- check type under cursor
vim.api.nvim_set_keymap('n', '<leader>rt', '<Cmd>call CocAction("doHover")<CR>', { noremap = true, silent = true, desc = "check type" })
-- go to definition
vim.api.nvim_set_keymap('n', '<leader>rd', '<Plug>(coc-definition)', { noremap = true, silent = true, desc = "goto definition" })
-- go to type definition
vim.api.nvim_set_keymap('n', '<leader>rT', '<Plug>(coc-type-definition)', { noremap = true, silent = true, desc = "goto type definition" })
-- go to implementation
vim.api.nvim_set_keymap('n', '<leader>ri', '<Plug>(coc-implementation)', { noremap = true, silent = true, desc = "goto implementation" })
-- go to references
vim.api.nvim_set_keymap('n', '<leader>rr', '<Plug>(coc-references)', { noremap = true, silent = true, desc = "goto references" })
-- restart
vim.api.nvim_set_keymap('n', '<leader>rR', '<Cmd>CocRestart<CR>', { noremap = true, silent = true, desc = "restart" })

-- =============================== 
-- git
vim.api.nvim_set_keymap('n', '<leader>gc', ':Git comment<CR>', { noremap = true, silent = true, desc = "git comment" })
vim.api.nvim_set_keymap('n', '<leader>gP', ':Git push<CR>', { noremap = true, silent = true, desc = "git push" })
vim.api.nvim_set_keymap('n', '<leader>gp', ':Git pull<CR>', { noremap = true, silent = true, desc = "git pull" })
vim.api.nvim_set_keymap('n', '<leader>gm', ':Git merge<CR>', { noremap = true, silent = true, desc = "git merge" })
vim.api.nvim_set_keymap('n', '<leader>ga', ':Git add<CR>', { noremap = true, silent = true, desc = "git add" })

