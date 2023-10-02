local M = {}

local defaults = {
	num_char = 50,
	symbols = 1,
	dark_theme = {
		Title = 'guifg=LightGrey ctermfg=7',
		Text = 'guifg=#afafaf ctermfg=145',
		Hr = 'guifg=LightGrey ctermfg=7',
		Border = 'guifg=LightGrey ctermfg=7'
	},
	light_theme = {
		Title = 'guifg=#000000 ctermfg=16',
		Text = 'guifg=#000000 ctermfg=16',
		Hr = 'guifg=#000000 ctermfg=16',
		Border = 'guifg=#3b4048 ctermfg=238'
	}
}

M.setup = function (options)
	-- Replace default options with user specified options
	-- tbl_deep_extend({behavior}, {...})
	M.config = vim.tbl_deep_extend('force',defaults,options)
end

-- M.setup{ key = 'value' } for setting up config
M.setup(defaults)

return M
