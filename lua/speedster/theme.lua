local config= require('speedster.config')
local cmd = vim.cmd
local o = vim.o
-- Highlighting lines
if o.background == "dark" then
	-- Dark
	cmd("highlight SpeedsterText " .. config.config.dark_theme.Text)
	cmd("highlight SpeedsterTitle " .. config.config.dark_theme.Title)
	cmd("highlight SpeedsterHr " .. config.config.dark_theme.Hr)
	cmd("highlight SpeedsterBorder " .. config.config.dark_theme.Border)
elseif o.background == "light" then
	-- Light
	cmd("highlight SpeedsterText " .. config.config.light_theme.Text)
	cmd("highlight SpeedsterTitle " .. config.config.light_theme.Title)
	cmd("highlight SpeedsterHr " .. config.config.light_theme.Hr)
	cmd("highlight SpeedsterBorder " .. config.config.light_theme.Border)
else
	print("Unknown colorscheme")
end
