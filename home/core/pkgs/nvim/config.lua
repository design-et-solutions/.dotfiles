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

require("tokyonight").setup({
    style = "night",

    -- Enable this to disable setting the background color
    transparent = false,

    -- Configure the colors used when opening a `:terminal` in Neovim
    terminal_colors = true,

    -- Use a darker background on sidebar-like windows
    sidebars = {"qf", "vista_kind", "terminal", "packer"},

    -- Change the "hint" color to the "orange" color, and make the "error" color bright red
    on_colors = function(colors)
      colors.hint = colors.orange
      colors.error = "#ff0000"
    end,

    -- Adjust specific highlight groups
    on_highlights = function(highlights, colors)
      highlights.LineNr = {
        fg = colors.yellow
      }
    end,

    -- Set style for various syntax groups
    styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        -- Background styles. Can be "dark", "transparent" or "normal"
        -- sidebars = "dark",
        -- floats = "dark",
    },

    -- Set dim_inactive to true to dim inactive windows
    -- dim_inactive = false,

    -- Set day_brightness to a float between 0 and 1 (default is 0.3)
    -- day_brightness = 0.3,

    -- Enabling this option will hide inactive statuslines and replace them with a thin border instead
    -- hide_inactive_statusline = false,

    -- Lualine options
    -- lualine_bold = false,
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
    sort = { sorter = "case_sensitive" },
    view = { width = 25 },
    renderer = { group_empty = true },
    filters = { dotfiles = false },
})

require("bufferline").setup{
    options = {
        mode = "buffers",
        numbers = "none",
        close_command = "bdelete! %d",
        right_mouse_command = "bdelete! %d",
        left_mouse_command = "buffer %d",
        middle_mouse_command = nil,
        indicator = {
            -- icon = '▎',
            style = 'icon',
        },
        buffer_close_icon = '',
        modified_icon = '●',
        close_icon = '',
        left_trunc_marker = '',
        right_trunc_marker = '',
        max_name_length = 18,
        max_prefix_length = 15,
        tab_size = 18,
        diagnostics = "nvim_lsp",
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        persist_buffer_sort = true,
        separator_style = "thin",
        enforce_regular_tabs = true,
        always_show_bufferline = true,
    }
}

require("toggleterm").setup{
    open_mapping = [[<c-\>]],
    direction = "float",
    float_opts = {
        winblend = 0,
    },
    highlights = {
        FloatBorder = {
          guifg = vim.api.nvim_get_hl_by_name("Normal", true).background,
          guibg = vim.api.nvim_get_hl_by_name("Normal", true).background,
        },
        NormalFloat = {
          guibg = vim.api.nvim_get_hl_by_name("Normal", true).background,
        },
    },
}

require("colorizer").setup{
    filetypes = { "*" },
    buftypes = {},
}

require("which-key").setup {
  plugins = {},
}

require("image").setup{
  backend = "kitty",
  integrations = {
    markdown = {
      enabled = true,
      clear_in_insert_mode = false,
      download_remote_images = true,
      only_render_image_at_cursor = false,
      filetypes = { "markdown", "vimwiki" }
    },
    neorg = {
      enabled = true,
      clear_in_insert_mode = false,
      download_remote_images = true,
      only_render_image_at_cursor = false,
      filetypes = { "norg" }
    }
  }
}

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
