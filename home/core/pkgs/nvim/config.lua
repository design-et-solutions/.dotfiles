require("plugins.nvim-tree")
require("plugins.bufferline")
require("plugins.toggleterm")
require("plugins.rest-nvim")
require("plugins.colorizer")
require("plugins.image")
require("plugins.which-key")
require("plugins.gruvbox")
require("plugins.tokyonight")

-- Set completeopt for better completion experience
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Copy/Past Clipboard
vim.opt.clipboard = 'unnamedplus'

-- Set colorscheme
vim.o.background = "light"
vim.cmd("colorscheme gruvbox")

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Enable 24-bit color
vim.opt.termguicolors = true

-- reloader
function _G.ReloadConfig()
    for name,_ in pairs(package.loaded) do
        if name:match('^user') then
            package.loaded[name] = nil
        end
    end
    dofile(vim.env.HOME .. "/.config/nvim/init.lua")
    vim.notify("Neovim configuration reloaded!", vim.log.levels.INFO)
end
