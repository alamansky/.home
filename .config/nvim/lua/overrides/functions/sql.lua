local M = {}

function M.run_query()
	local sql
	if vim.fn.mode():find("[vV\22]") then
		local s = vim.fn.line("v")
		local e = vim.fn.line(".")
		if s > e then
			s, e = e, s
		end
		sql = table.concat(vim.api.nvim_buf_get_lines(0, s - 1, e, false), "\n")
	else
		sql = vim.api.nvim_get_current_line()
	end

	local conn = vim.fn.expand("%:t:r")
	if conn == "" then
		vim.notify("Buffer has no file name", vim.log.levels.WARN)
		return
	end

	-- verify the connection exists in the usql config
	local usql_config = vim.env.USQL_CONFIG or vim.fn.expand("~/.config/usql/config.yaml")
	local check = vim.fn.system({ "qq", "-r", string.format('.connections["%s"] // empty', conn), usql_config })
	if vim.trim(check) == "" then
		vim.notify("No usql connection found for: " .. conn, vim.log.levels.WARN)
		return
	end

	local output_dir = vim.fn.expand("%:p:h") .. "/output"
	vim.fn.mkdir(output_dir, "p")
	local output_file = output_dir .. "/" .. conn .. ".csv"

	local script = vim.fn.expand("~/.config/claude/skills/query-db/scripts/query_through_tunnel.sh")
	local out = {}
	vim.notify("Running query on " .. conn .. "…")
	vim.fn.jobstart({ "bash", script, conn, sql }, {
		stdout_buffered = true,
		on_stdout = function(_, data)
			vim.list_extend(out, data)
		end,
		on_exit = function(_, code)
			vim.schedule(function()
				vim.fn.writefile(out, output_file)
				if code ~= 0 then
					vim.notify("Query failed (exit " .. code .. "). See " .. output_file, vim.log.levels.ERROR)
				end
				-- reuse an existing window showing this file; open a new split otherwise
				local buf = vim.fn.bufnr(output_file)
				local existing_win = nil
				if buf ~= -1 then
					for _, w in ipairs(vim.api.nvim_list_wins()) do
						if vim.api.nvim_win_get_buf(w) == buf then
							existing_win = w
							break
						end
					end
				end
				if existing_win then
					vim.api.nvim_win_call(existing_win, function()
						vim.cmd("edit!")
						vim.cmd("CsvViewEnable")
					end)
				else
					vim.cmd("split " .. vim.fn.fnameescape(output_file))
					vim.cmd("CsvViewEnable")
				end
			end)
		end,
	})
end

function M.csv_to_json()
	local conn = vim.fn.expand("%:t:r")
	if conn == "" then
		vim.notify("Buffer has no file name", vim.log.levels.WARN)
		return
	end

	local buf_dir = vim.fn.expand("%:p:h")
	local output_dir = buf_dir:match("output$") and buf_dir or (buf_dir .. "/output")
	local csv_file = output_dir .. "/" .. conn .. ".csv"
	local json_file = output_dir .. "/" .. conn .. ".json"

	if vim.fn.filereadable(csv_file) == 0 then
		vim.notify("No CSV output found at " .. csv_file, vim.log.levels.WARN)
		return
	end

	local out = {}
	local cmd = "qq . "
		.. vim.fn.shellescape(csv_file)
		.. " -o json | jq 'walk(if type == \"string\" then (. as $s | try fromjson catch $s) else . end)'"
	vim.fn.jobstart({ "bash", "-c", cmd }, {
		stdout_buffered = true,
		on_stdout = function(_, data)
			vim.list_extend(out, data)
		end,
		on_exit = function(_, code)
			vim.schedule(function()
				if code ~= 0 then
					vim.notify("qq/jq conversion failed (exit " .. code .. ")", vim.log.levels.ERROR)
					return
				end
				vim.fn.writefile(out, json_file)
				local buf = vim.fn.bufnr(json_file)
				local existing_win = nil
				if buf ~= -1 then
					for _, w in ipairs(vim.api.nvim_list_wins()) do
						if vim.api.nvim_win_get_buf(w) == buf then
							existing_win = w
							break
						end
					end
				end
				if existing_win then
					vim.api.nvim_win_call(existing_win, function()
						vim.cmd("edit!")
					end)
				else
					vim.cmd("vsplit " .. vim.fn.fnameescape(json_file))
				end
			end)
		end,
	})
end

return M
