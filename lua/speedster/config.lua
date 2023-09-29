local M = {}

local defaults = {
	num_char = 50,
	symbols = 1,
	-- theme = ''
}

M.setup = function (options)
	-- Replace default options with user specified options
	-- tbl_deep_extend({behavior}, {...})
	M.config = vim.tbl_deep_extend('force',defaults,options)
end

-- M.setup{ key = 'value' } for setting up config
M.setup(defaults)

return M
