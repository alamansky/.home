local M = {}

function M.run_cx_logs()
	local query
	if vim.fn.mode():find("[vV\22]") then
		local s = vim.fn.line("v")
		local e = vim.fn.line(".")
		if s > e then
			s, e = e, s
		end
		query = table.concat(vim.api.nvim_buf_get_lines(0, s - 1, e, false), "\n")
	else
		query = vim.api.nvim_get_current_line()
	end
	query = query:gsub("\\%$", "$")

	local stem = vim.fn.expand("%:t:r")
	if stem == "" then
		vim.notify("Buffer has no file name", vim.log.levels.WARN)
		return
	end

	local output_dir = vim.fn.expand("%:p:h") .. "/output"
	vim.fn.mkdir(output_dir, "p")
	local output_file = output_dir .. "/" .. stem .. ".json"

	local cmd = 'cx logs "$1" | jq "[.[].userData.body | try fromjson // .]"'
	local out = {}
	vim.notify("Running cx logs for " .. stem .. "…")
	vim.fn.jobstart({ "bash", "-c", cmd, "--", query }, {
		stdout_buffered = true,
		on_stdout = function(_, data)
			vim.list_extend(out, data)
		end,
		on_exit = function(_, code)
			vim.schedule(function()
				vim.fn.writefile(out, output_file)
				if code ~= 0 then
					vim.notify("cx logs failed (exit " .. code .. "). See " .. output_file, vim.log.levels.ERROR)
				end
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
					end)
				else
					vim.cmd("split " .. vim.fn.fnameescape(output_file))
				end
			end)
		end,
	})
end

return M
