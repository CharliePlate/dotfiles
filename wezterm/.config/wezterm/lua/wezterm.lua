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

config.color_schemes = {
	["Vague"] = {
		foreground = "#cdcdcd",
		background = "#141415",

		cursor_bg = "#cdcdcd",
		cursor_fg = "#141415",
		cursor_border = "#cdcdcd",

		selection_fg = "#cdcdcd",
		selection_bg = "#252530",

		ansi = {
			"#252530", -- 0: black
			"#d8647e", -- 1: red
			"#7fa563", -- 2: green
			"#f3be7c", -- 3: yellow
			"#6e94b2", -- 4: blue
			"#bb9dbd", -- 5: magenta
			"#aeaed1", -- 6: cyan
			"#cdcdcd", -- 7: white
		},

		brights = {
			"#606079", -- 8: bright black
			"#e08398", -- 9: bright red
			"#99b782", -- 10: bright green
			"#f5cb96", -- 11: bright yellow
			"#8ba9c1", -- 12: bright blue
			"#c9b1ca", -- 13: bright magenta
			"#bebeda", -- 14: bright cyan
			"#d7d7d7", -- 15: bright white
		},
	},
}

-- Set active theme
config.color_scheme = "Vague"

config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false
config.use_ime = false

return config
