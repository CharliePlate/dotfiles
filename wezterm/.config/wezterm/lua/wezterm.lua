---@type Wezterm
local wezterm = require("wezterm")

local config = {}

local wezterm_config_nvim = wezterm.plugin.require("/Users/charlieplate/.config/wezterm/wezterm-config.nvim/")

wezterm.on("user-var-changed", function(window, _, name, value)
	local overrides = window:get_config_overrides() or {}
	overrides = wezterm_config_nvim.override_user_var(overrides, name, value)
	window:set_config_overrides(overrides)
end)

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
config.font = wezterm.font("PragmasevkaNerdFont Nerd Font")
config.font_size = 20.0
config.window_decorations = "RESIZE"
config.term = "wezterm"
config.color_scheme = "Rosé Pine Moon (Gogh)"

return config
