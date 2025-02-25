local dir = "/.codecompanion-chat"

vim.api.nvim_create_user_command("SaveChat", function()
	if vim.bo.filetype ~= "codecompanion" then
		vim.notify("This command can only be used in CodeCompanion chat", vim.log.levels.ERROR)
		return
	end

	local save_dir = vim.fn.getcwd() .. dir
	if vim.fn.isdirectory(save_dir) == 0 then
		vim.fn.mkdir(save_dir, "p")

        -- Recursive gitignore
		local gitignore_path = save_dir .. "/.gitignore"
		vim.fn.writefile({ "*" }, gitignore_path)
	end

	-- Prompt for title
	vim.ui.input({
		prompt = "Enter chat title: ",
		default = "",
	}, function(title)
		if not title or title == "" then
			vim.notify("Save cancelled", vim.log.levels.WARN)
			return
		end
		-- Replace spaces with underscores and remove special characters
		title = title:gsub("%s+", "_"):gsub("[^%w_-]", "")
		local filename = os.date("%d%m%y") .. "_" .. title .. ".md"
		local filepath = save_dir .. "/" .. filename

		local success = vim.cmd("write! " .. filepath)

		if success then
			vim.notify("Chat saved to " .. filepath, vim.log.levels.INFO)
		end
	end)
end, {})

vim.api.nvim_create_user_command("LoadChat", function()
	if vim.bo.filetype ~= "codecompanion" then
		vim.notify("This command can only be used in CodeCompanion chat", vim.log.levels.ERROR)
		return
	end

	local save_dir = vim.fn.getcwd() .. dir

	if vim.fn.isdirectory(save_dir) == 0 then
		vim.notify("No codecompanion directory found", vim.log.levels.ERROR)
		return
	end

	-- Get all chat files
	local files = vim.fn.globpath(save_dir, "*.md", false, true)
	if #files == 0 then
		vim.notify("No saved chats found", vim.log.levels.ERROR)
		return
	end

	-- Create table with file info for sorting
	local file_info = {}
	for _, file in ipairs(files) do
		local filename = vim.fn.fnamemodify(file, ":t")
		-- Extract date and title
		local date_str, title = filename:match("(%d%d%d%d%d%d)_(.+)%.md$")
		if date_str and title then
			table.insert(file_info, {
				filename = filename,
				date_str = date_str,
				title = title:gsub("_", " "),
				full_path = file,
			})
		end
	end

	-- Sort by date (newest first)
	table.sort(file_info, function(a, b)
		return a.date_str > b.date_str
	end)

	-- Format for display
	local formatted_items = {}
	local file_lookup = {}
	for _, info in ipairs(file_info) do
		local display_text = string.format(
			"%s - %s",
			os.date("%d/%m/%y", tonumber(info.date_str:match("(%d%d)(%d%d)(%d%d)"))),
			info.title
		)
		table.insert(formatted_items, display_text)
		file_lookup[display_text] = info.full_path
	end

	vim.ui.select(formatted_items, {
		prompt = "Select chat to load:",
		format_item = function(item)
			return item
		end,
	}, function(choice)
		if choice then
			local filepath = file_lookup[choice]
			local content = vim.fn.readfile(filepath)
			local bufnr = vim.api.nvim_get_current_buf()
			vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, content)
			vim.notify("Chat loaded from " .. filepath, vim.log.levels.INFO)
		end
	end)
end, {})
