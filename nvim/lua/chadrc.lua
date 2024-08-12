-- This file  needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua

vim.opt.termguicolors = true

---@type ChadrcConfig
local M = {}

M.ui = {
  -- changed_themes = {
  --   nord = {
  --     base_16 = {
  --       base00 = "#141929",
  --       base01 = "#141929",
  --       base02 = "#D4DFED", -- disable by visual
  --       base03 = "#68818D",
  --       base04 = "#D4DFED",
  --       base05 = "#D4DFED",
  --       base06 = "#0000FF",
  --       base07 = "#9D0208",
  --       base08 = "#FF85A1",
  --       base09 = "#eb5e28",
  --       base0A = "#FE9D5D",
  --       base0B = "#e07a5f",
  --       base0C = "#7EBDC2",
  --       base0D = "#FFEE93",
  --       base0E = "#F66C51",
  --       base0F = "#76A4E5",
  --     },
  --     base_30 = {
  --       white = "#D4DFED",
  --       darker_black = "#141929",
  --       black = "#141929", --  nvim bg
  --       black2 = "#141929",
  --       one_bg = "#D4DFED", -- real bg of onedark
  --       one_bg2 = "#00FFFF",
  --       one_bg3 = "#FE9D5D",
  --       grey = "#eb5e28",
  --       grey_fg = "#68818D",
  --       grey_fg2 = "#6e6f79",
  --       light_grey = "#D4DFED",
  --       red = "#F66C51",
  --       baby_pink = "#FFFF00",
  --       pink = "#FF85A1",
  --       line = "#D4DFED", -- for lines like vertsplit
  --       green = "#D4DFED",
  --       vibrant_green = "#AA00AA",
  --       nord_blue = "#D4DFED",
  --       blue = "#D4DFED",
  --       yellow = "#FFEE93",
  --       sun = "#AA00FF",
  --       purple = "#FFAA00",
  --       dark_purple = "#D295F6",
  --       teal = "#FF00AA",
  --       orange = "#0000AA",
  --       cyan = "#7EBDC2",
  --       statusline_bg = "#141929",
  --       lightbg = "#68818D",
  --       pmenu_bg = "#D4DFED",
  --       folder_bg = "#D4DFED",
  --     },
  --   },
  -- },
	theme = "nord",

	-- hl_override = {
	--    Visual = { fg = "#141929", bg = "#D4DFED" },
	--    CursorLineNr = { fg = "#FFEE93", bold = true },
	-- },
}

return M
