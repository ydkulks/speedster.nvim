-- Global variable to print table
P = function (options)
	vim.inspect(options)
end

-- Command to run plugin
vim.cmd("command! Speedster lua require('speedster').run()")

return P
