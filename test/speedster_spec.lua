describe("speedster",function ()
	it("can be required",function ()
		require("speedster")
	end)
	it("can run run()",function ()
		require("speedster").run()
	end)
	it("mapped 'q' to :close",function ()
		vim.api.nvim_buf_get_keymap(0,'n')
	end)
end)
