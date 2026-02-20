---@type Wezterm
local wezterm = require("wezterm")

local config = {}

wezterm.on("clear-overrides", function(window, _)
	window:set_config_overrides({})
	window:toast_notification("wezterm", "config overrides cleared", nil, 2000)
end)

config.window_padding = {
	left = "0.5cell",
	right = "0.5cell",
	top = "0.5cell",
	bottom = "0cell",
}

-- disable the command w keybind
config.keys = {
	{
		key = "w",
		mods = "CMD",
		action = wezterm.action.DisableDefaultAssignment,
	},
	{
		key = "f",
		mods = "CMD",
		action = wezterm.action.DisableDefaultAssignment,
	},
	{
		key = "X",
		mods = "CTRL|SHIFT",
		action = wezterm.action.EmitEvent("clear-overrides"),
	},
}

config.automatically_reload_config = true
config.use_ime = false
config.font = wezterm.font("Pragmasevka Nerd Font")
config.font_size = 20.0
config.window_decorations = "RESIZE"
config.term = "wezterm"
config.colors = {
	foreground = "#FAFFF6",
	background = "#172030",
	cursor_bg = "#c6797e",
	cursor_fg = "#172030",
	cursor_border = "#c6797e",
	selection_bg = "#5D636E",
	selection_fg = "#FAFFF6",
	split = "#1F2A3F",
	compose_cursor = "#eabe9a",

	ansi = {
		"#0E131D", -- black
		"#c6797e", -- red
		"#A3B09A", -- green
		"#eabe9a", -- yellow/orange
		"#6e94b9", -- blue
		"#b18bb1", -- magenta
		"#88C0D0", -- cyan
		"#E8E9EB", -- white
	},
	brights = {
		"#5D636E", -- bright black
		"#DB6E8F", -- bright red
		"#B9C4B0", -- bright green
		"#F7E3AF", -- bright yellow
		"#5D80AE", -- bright blue
		"#F9B5AC", -- bright magenta/salmon
		"#7ea9a9", -- bright cyan/teal
		"#FAFFF6", -- bright white
	},

	tab_bar = {
		background = "#101828",
		active_tab = {
			bg_color = "#172030",
			fg_color = "#FAFFF6",
		},
		inactive_tab = {
			bg_color = "#101828",
			fg_color = "#64727d",
		},
		inactive_tab_hover = {
			bg_color = "#1F2A3F",
			fg_color = "#A7ACB9",
		},
		new_tab = {
			bg_color = "#101828",
			fg_color = "#64727d",
		},
		new_tab_hover = {
			bg_color = "#1F2A3F",
			fg_color = "#A7ACB9",
		},
	},
}
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false
config.use_ime = false
config.default_cursor_style = 'BlinkingBlock'


return config
