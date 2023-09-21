local api = vim.api
local cmd = vim.cmd
local fn = vim.fn
local buf,input_buf
local M = {}

local function set_mappings()
	local buf_list = {buf,input_buf}
	local nmappings = {
		q = 'vim.cmd(":close");vim.cmd(":close")'
	}

	-- Normal mode mappings
	for _,bv in pairs(buf_list)do
		for k,v in pairs(nmappings) do
			api.nvim_buf_set_keymap(bv,'n',k,':lua '..v..'<cr>',{
				nowait = true, noremap = true, silent =true
			})
		end
	end
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

local function get_data(menu,message)
	-- Horizontal line
	local function hr(char)
		local width = api.nvim_win_get_width(0)
		return string.rep(char,width)
	end
	-- Center the text
	local function center(str)
		local width = api.nvim_win_get_width(0)
		local shift = math.floor(width / 2) - math.floor(string.len(str) / 2)
		return string.rep(' ',shift) .. str
	end

	api.nvim_buf_set_lines(buf, 0, -1, false, {
		center('Speedster'),
		menu,
		hr('─'),
		'','',
		center(message)
	})
	-- Highlighting lines
	api.nvim_buf_add_highlight(buf,-1,'Keyword',0,0,-1)
	api.nvim_buf_add_highlight(buf,-1,'Comment',2,0,-1)
	-- api.nvim_buf_add_highlight(buf,-1,'Function',3,0,-1)
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
	api.nvim_buf_set_option(input_buf, "buftype", "prompt")
	fn.prompt_setcallback(input_buf, function (input)
		if input == 'start' or input == 'Start' then
			-- cmd('stopinsert')
			local menu = 'g? - help'
			local message = 'Stop, get some help'
			get_data(menu,message)
		elseif input == 'g?' then
			local menu = 'g? - help'
			-- May be converting this message string variable to 
			-- a table might help to itirate through bunch of line
			-- to add in the buffer
			local message = "start : Start  q : Quit  g? : help"
			get_data(menu,message)
		elseif input == 'q' then
			cmd(":close")
			cmd(":close")
		end
	end)
	fn.prompt_setprompt(input_buf,"》")
	cmd('startinsert')
end

M.run = function ()
	local menu = 'g? - help'
	local start_msg = 'Type "start" to begin'
	open_window()
	get_data(menu,start_msg)
	input_field()
	set_mappings()
end

return M
