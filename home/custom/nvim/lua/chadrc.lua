-- This file  needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua

vim.opt.termguicolors = true

---@type ChadrcConfig
local M = {}

M.ui = {
  icons = true,
	theme = "nord",
}

return M
