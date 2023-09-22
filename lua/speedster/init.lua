local api = vim.api
local cmd = vim.cmd
local fn = vim.fn
local buf,input_buf
local menu = ' g? - help'
table.unpack = table.unpack or unpack
-- Refer this github issue for more info on above line
-- https://github.com/hrsh7th/nvim-cmp/issues/1017#issuecomment-1141440976
local wordlist = {
	  "apple", "banana", "cherry", "orange", "grape",
    "elephant", "giraffe", "zebra", "tiger", "lion",
    "house", "car", "tree", "flower", "mountain"
}
local randomWords = {}
local M = {}

local function generateRandomWords()
  math.randomseed(os.time())
  local words = {}
  local randomString = ""
	local maxLength = 10

  while #randomString < maxLength do
    local randomIndex = math.random(1, #wordlist)
    local randomWord = wordlist[randomIndex]
    if #randomString + #randomWord + 1 <= maxLength then
      words[#words + 1] = randomWord
      randomString = table.concat(words, " ")
    else
      break
    end
  end

  return randomString
end

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

local function get_data(message)
	-- Horizontal line
	local function hr(char)
		local width = api.nvim_win_get_width(0)
		return string.rep(char,width)
	end
	-- Center the text
	local function center(contents)
    local width = api.nvim_win_get_width(0)
    local centeredContents = {}
    for _, str in ipairs(contents) do
        local shift = math.floor(width / 2) - math.floor(string.len(str) / 2)
        local centeredStr = string.rep(' ', shift) .. str
        table.insert(centeredContents, centeredStr)
    end

    return centeredContents
	end

	local title = {'Speedster'}
	api.nvim_buf_set_lines(buf, 0, -1, false, {
		table.unpack(center(title)),
		menu,
		hr('─'),
		'',
		table.unpack(center(message))
	})
	-- Highlighting lines
	api.nvim_buf_add_highlight(buf,-1,'Keyword',0,0,-1)
	api.nvim_buf_add_highlight(buf,-1,'Comment',2,0,-1)

	api.nvim_buf_add_highlight(buf,-1,'Function',4,0,-1)
	api.nvim_buf_add_highlight(buf,-1,'Function',5,0,-1)
	api.nvim_buf_add_highlight(buf,-1,'Function',6,0,-1)
	api.nvim_buf_add_highlight(buf,-1,'Function',7,0,-1)
	api.nvim_buf_add_highlight(buf,-1,'Function',8,0,-1)
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

	-- Create prompt window
	local input_win = api.nvim_open_win(input_buf,true,input_win_opts)
	api.nvim_set_current_win(input_win)
	api.nvim_buf_set_option(input_buf, "buftype", "prompt")
	-- Callback function in response to input
	fn.prompt_setcallback(input_buf, function (input)
		-- Condition to start, get help, quit
		if input == 's' then
			randomWords = {}
			local randomWord = generateRandomWords()
			table.insert(randomWords,randomWord)
			local message = randomWords
			return get_data(message)
		elseif input == 'g?' then
			local message = {
				"[s]  : start",
				"[q]  :  quit",
				"[g?] :  help"
			}
			return get_data(message)
		elseif input == 'q' then
			cmd(":close")
			cmd(":close")
		elseif input == randomWords[1] then
			randomWords = {}
			local randomWord = generateRandomWords()
			table.insert(randomWords,randomWord)
			local message = randomWords
			return get_data(message)
		end
	end)
	-- fn.prompt_setprompt(input_buf,"》")
	fn.prompt_setprompt(input_buf," ▶ ")
	cmd('startinsert')
end

M.run = function ()
	local start_msg = {'Type "s" to start'}
	open_window()
	get_data(start_msg)
	input_field()
	set_mappings()
end

return M
