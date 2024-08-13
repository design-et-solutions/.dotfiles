local wezterm = require 'wezterm'

local function font_with_fallback(name, params)
	local names = { name, "0xProto" }
	return wezterm.font_with_fallback(names, params)
end

local font_name = "0xProto"

local config = {}

-- OpenGL for GPU acceleration, Software for CPU
config.front_end = "OpenGL"

config.color_scheme = 'Catppuccin Mocha'

-- Font config
config.font = font_with_fallback(font_name)
config.font_rules = {
    {
        italic = true,
        font = wezterm.font {
            family = "0xProto",
            weight = "Regular",
            style = "Italic",
        },
    },
    {
        intensity = "Bold",
        font = wezterm.font {
            family = "0xProto",
            weight = "Bold",
        },
    },
    {
        intensity = "Bold",
        italic = true,
        font = wezterm.font {
            family = "0xProto",
            weight = "Bold",
            style = "Italic",
        },
    },
}

config.warn_about_missing_glyphs = false
config.font_size = 10
config.line_height = 1.0
config.dpi = 96.0

-- Cursor style
default_cursor_style = "BlinkingUnderline"

-- Enable Wayland (default is true)
config.enable_wayland = true

-- Or disable Wayland and force X11
-- config.enable_wayland = false

-- Keybinds
config.disable_default_key_bindings = true

-- Aesthetic Night Colorscheme
config.bold_brightens_ansi_colors = true

-- Padding
config.window_padding = {
    left = 25,
    right = 25,
    top = 25,
    bottom = 25,
}

-- Tab Bar
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.show_tab_index_in_tab_bar = false
config.tab_bar_at_bottom = true

-- General
config.automatically_reload_config = true
config.inactive_pane_hsb = { saturation = 1.0, brightness = 1.0 }
config.window_background_opacity = 0.5
config.window_close_confirmation = "NeverPrompt"

config.window_frame = { 
    active_titlebar_bg = "#45475a", 
    font = font_with_fallback(font_name, { bold = true }) 
}
return config