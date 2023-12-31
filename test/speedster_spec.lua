local describe = describe
local it = it
local api = vim.api
local fn = vim.fn
describe("speedster",function ()
	it("can be required",function ()
		require("speedster")
	end)
	it("config can be required",function ()
		require("speedster.config")
	end)
	it("can run run()",function ()
		require("speedster").run()
	end)
	it("mapped 'q' to :close",function ()
		api.nvim_buf_get_keymap(0,'n')
	end)
	it("has access to file",function ()
    local runtime_dir = fn.stdpath('data') .. '/site/pack/packer/start/' .. 'speedster.nvim'
    local filepath = runtime_dir .. "/lua/speedster/wordlist.txt"
    local f = assert(io.open(filepath,'r'))
    f:close()
	end)
end)
