local api = vim.api
local buf
local M = {}

M.setup = function ()
	-- print(vim.o.ft)
end

local function set_mappings()
	local mappings = {
		q = 'vim.cmd(":close")'
	}

	for k,v in pairs(mappings) do
		api.nvim_buf_set_keymap(buf,'n',k,':lua '..v..'<cr>',{
			nowait = true, noremap = true, silent =true
		})
	end
end

local function center(str)
	local width = api.nvim_win_get_width(0)
	local shift = math.floor(width / 2) - math.floor(string.len(str) / 2)
	return string.rep(' ',shift) .. str
end

local function hr(char)
	local width = api.nvim_win_get_width(0)
	return string.rep(char,width)
end

local function open_window()
	-- create new emtpy throwaway buffer
  buf = api.nvim_create_buf(false, true)

  api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')

  -- get dimensions
  local width = api.nvim_get_option("columns")
  local height = api.nvim_get_option("lines")

  -- calculate our floating window size
  local win_height = 10
	-- local win_height = math.ceil(height * 0.8 - 4)
  local win_width = math.ceil(width * 0.8)

  -- and its starting position
  -- local row = math.ceil((height - win_height) / 2 - 1)
  local row = math.ceil((height) / 3 )
  local col = math.ceil((width - win_width) / 2)

  -- set some options
  local opts = {
    style = "minimal",
	  border = "rounded",
    relative = "editor",
    width = win_width,
    height = win_height,
    row = row,
    col = col
  }

  -- and finally create it with buffer attached
  api.nvim_open_win(buf, true, opts)
end

local function get_data()
	local test = 'Typing test 101!'
	api.nvim_buf_set_lines(buf, 0, -1, false, {
		center('Speedster'),
		' q - Quit',
		hr('─'),
		test,
		'',''
	})
	-- Highlighting lines
	api.nvim_buf_add_highlight(buf,-1,'String',0,0,-1)
	api.nvim_buf_add_highlight(buf,-1,'VertSplit',2,0,-1)
	api.nvim_buf_add_highlight(buf,-1,'Pmenu',3,0,-1)
	api.nvim_win_set_cursor(0,{6,0})
end

M.run = function ()
	open_window()
	set_mappings()
	get_data()
end

return M
