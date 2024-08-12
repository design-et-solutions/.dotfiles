require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
-- LSP-related mappings with buffer scope
local keymap_opts = { buffer = buffer }

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")


-- LSP actions
-- common
map("n", "gk", vim.lsp.buf.hover, keymap_opts)
map("n", "gs", vim.lsp.buf.signature_help, keymap_opts)
map("n", "ga", vim.lsp.buf.implementation, keymap_opts)
map("n", "gd", vim.lsp.buf.definition, keymap_opts)
map("n", "gD", vim.lsp.buf.declaration, keymap_opts)
map("n", "<leader>D", vim.lsp.buf.type_definition, keymap_opts)
map("n", "gr", vim.lsp.buf.references, keymap_opts)
map("n", "<leader>q", '<cmd>lua vim.diagnostic.setloclist()<CR>', { noremap = true, silent = true })

-- map("n", "ga", vim.lsp.buf.code_action, keymap_opts)
-- map("n", "gK", vim.lsp.buf.type_definition, keymap_opts) -- rust analyzer go to type definition
-- map("n", "gd", vim.lsp.buf.definition, keymap_opts) -- rust to definition
-- map("n", "gr", vim.lsp.buf.references, keymap_opts) -- rust go to references
-- map("n", "gl", '<cmd>lua vim.diagnostic.setloclist()<CR>', { noremap = true, silent = true }) -- rust open diagnostic2A3A

-- uncommon


-- Goto previous/next diagnostic warning/error
-- map("n", "g[", vim.diagnostic.goto_prev, keymap_opts)
-- map("n", "g]", vim.diagnostic.goto_next, keymap_opts)

-- others
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
