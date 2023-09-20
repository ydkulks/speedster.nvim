local api = vim.api
local buf,input_buf
local start_msg
local M = {}

local function read()
	local lnum = 1
	local buffer_line = api.nvim_buf_get_lines(input_buf,lnum-1,lnum,false)[1]
	api.nvim_buf_set_lines(buf, 0, -1, false, {
		buffer_line,
		'Started'
	})
end

local function set_mappings()
	local buf_list = {buf,input_buf}
	local nmappings = {
		q = 'vim.cmd(":close");vim.cmd(":close")'
	}

	--[[
	local imappings = {
		['<cr>'] = print("hi")
	}

	-- Loop through all buffers and map keys for each
	for k,v in pairs(imappings) do
		api.nvim_buf_set_keymap(input_buf,'i',k,':lua '..v()..'<cr>',{
			nowait = true, noremap = true, silent =true
		})
	end
	]]--
	-- Normal mode mappings
	for _,bv in pairs(buf_list)do
		for k,v in pairs(nmappings) do
			api.nvim_buf_set_keymap(bv,'n',k,':lua '..v..'<cr>',{
				nowait = true, noremap = true, silent =true
			})
		end
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
    relative = "win",
    width = win_width,
    height = win_height,
    row = row,
    col = col
  }

  -- and finally create it with buffer attached
  api.nvim_open_win(buf, true, opts)
end

local function get_data()
	-- local start_msg = center('Type "start" to begin')
	start_msg = center('Type "start" to begin')
	api.nvim_buf_set_lines(buf, 0, -1, false, {
		center('Speedster'),
		' q - Quit',
		hr('─'),
		start_msg
	})
	-- Highlighting lines
	api.nvim_buf_add_highlight(buf,-1,'Keyword',0,0,-1)
	api.nvim_buf_add_highlight(buf,-1,'Comment',2,0,-1)
	api.nvim_buf_add_highlight(buf,-1,'Function',3,0,-1)
end


local function input_field()
	input_buf = api.nvim_create_buf(false,true)
	-- Window dimensions
  local width = api.nvim_get_option("columns")
  local height = api.nvim_get_option("lines")
	-- Window position
  local win_width = math.ceil(width * 0.8)
	local input_win_opts = {
		style = "minimal",
	  border = "rounded",
		relative = "editor",
		width = win_width,
		height = 1,
		row = math.ceil((height) / 3 ) + 12,
		col = math.ceil((width - win_width) / 2),
	}

	local input_win = api.nvim_open_win(input_buf,true,input_win_opts)
	api.nvim_set_current_win(input_win)
	vim.cmd('startinsert')

	-- Calling other functions
	-- read_buffer()
	set_mappings()
end

M.run = function ()
	open_window()
	get_data()
	input_field()
	get_data()
	-- Go to insert mode after loading window
	-- api.nvim_feedkeys('a','n',true)
	-- read_buffer()
end

return M
