-- TODO: disable coc-pairs like plugins in input_buf
local api = vim.api
local cmd = vim.cmd
local fn = vim.fn
local buf,input_buf
local menu = ' g? - help'
local start_time,end_time
table.unpack = table.unpack or unpack
-- Refer this github issue for more info on above line
-- https://github.com/hrsh7th/nvim-cmp/issues/1017#issuecomment-1141440976
local cwd = fn.getcwd()
local filepath = cwd .. "/lua/speedster/wordlist.txt"

--test
local f = assert(io.open(filepath,'r'))
f:close()

local randomWords = {}
local M = {}
local symbols = '12345678901234567890_+-=;:,./"?><[]{}'

local function wordsWithSymbols(randomWord)
	-- Extract the string from the table
  local inputString = randomWord

  -- Split the string into words
  local words = {}
  for word in inputString:gmatch("%S+") do
      table.insert(words, word)
  end

  -- Select a random index for the word to be replaced
  local randomIndex = math.random(1, #words)

  -- Get the selected word and its length
  local selectedWord = words[randomIndex]
  local wordLength = #selectedWord

  -- Generate a random symbol from the set for each character in the word
  local symbolString = ''
  for i = 1, wordLength do
    local randomSymbolIndex = math.random(1, #symbols)
    local randomSymbol = symbols:sub(randomSymbolIndex, randomSymbolIndex)
    symbolString = symbolString .. randomSymbol
  end

  -- Replace the selected word with the generated symbols
  words[randomIndex] = symbolString

  -- Reconstruct the modified string
  local modifiedString = table.concat(words, ' ')
	return modifiedString
end

local function getWords(randomIndex, file)
  local i = 1
  local lines = {}  -- Store lines in a table for easier access

  for line in io.lines(file) do
    -- lines[i] = line:sub(1,-2)
    lines[i] = line
    i = i + 1
  end

  -- Check if the randomIndex is valid
  if randomIndex >= 1 and randomIndex <= i - 1 then
    -- Get the line at the randomIndex
    local currentLine = lines[randomIndex]

    -- Check if the line is empty (contains no characters)
    if #currentLine > 0 then
      return currentLine
    else
      -- If the line is empty, look for the previous line (-1) and the next line (+1)
      local previousLine = lines[randomIndex - 1]
      local nextLine = lines[randomIndex + 1]

      -- Return the previous line if it has characters, otherwise return the next line
      if previousLine and #previousLine > 0 then
        return previousLine
      elseif nextLine and #nextLine > 0 then
        return nextLine
      end
    end
  end
end

local function generateRandomWords()
  math.randomseed(os.time())
  local words = {}
  local randomString = ""
	local maxLength = 50

  while #randomString < maxLength do
    -- local randomIndex = math.random(1, #symbols)
    -- local randomWord = symbols[randomIndex]
    local randomIndex = math.random(1, 10000)
		local randomWord = getWords(randomIndex,filepath)

		-- Check the length of line to decide to weather to add the word to the
		-- table or not
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
		q = 'vim.cmd(":q!");vim.cmd(":close")'
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
	start_time = 0
	local function calculate_time_diff()
		end_time = vim.loop.hrtime()
		local diff_seconds = (end_time - start_time)/1e9
		start_time = end_time

		-- Formatting
		local time_taken = string.format("%.6f", diff_seconds)

		return time_taken
	end
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
			calculate_time_diff()
			randomWords = {}
			local randomWord = generateRandomWords()
			randomWord = wordsWithSymbols(randomWord)
			table.insert(randomWords,randomWord)
			return get_data(randomWords)
		elseif input == 'g?' then
			local message = {
				"[s]  : start",
				"[q]  :  quit",
				"[g?] :  help"
			}
			return get_data(message)
		elseif input == 'q' then
		  end_time = 0
			cmd(":q!")
			cmd(":close")
		elseif input == randomWords[1] then
			local time_diff = calculate_time_diff()
			menu = " g? - help" .. " Time: " .. time_diff
			-- refresh memory
			randomWords = {}
			-- Generate random set of words to form a line
			local randomWord = generateRandomWords()
			-- Replace word with symbols
			randomWord = wordsWithSymbols(randomWord)
			table.insert(randomWords,randomWord)
			return get_data(randomWords)
		end
	end)
	-- fn.prompt_setprompt(input_buf,"》")
	fn.prompt_setprompt(input_buf," ▶ ")
	cmd('startinsert')
end

local function disable_plugins(buffer)
	api.nvim_buf_set_var(buffer,'loaded_matchparen',1)
end

M.run = function ()
	local start_msg = {'Type "s" to start'}
	open_window()
	get_data(start_msg)
	input_field()
	set_mappings()
	disable_plugins(input_buf)
end

return M
