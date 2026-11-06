local M = {}

-- yank GitHub permalink for the current line or visual selection
function M.github_url(start_line, end_line)
	local file = vim.api.nvim_buf_get_name(0)
	if file == "" then
		vim.notify("Buffer has no file path", vim.log.levels.WARN)
		return
	end

	local function sh(cmd)
		local out = vim.fn.system(cmd)
		if vim.v.shell_error ~= 0 then
			return nil
		end
		return vim.trim(out)
	end

	local root = sh("git rev-parse --show-toplevel")
	if not root then
		vim.notify("Not inside a git repo", vim.log.levels.WARN)
		return
	end

	local sha = sh("git rev-parse HEAD")
	local remote = sh("git remote get-url origin")
	if not sha or not remote then
		vim.notify("Could not read git metadata", vim.log.levels.WARN)
		return
	end

	-- Convert SSH (including custom host aliases) or HTTPS remote to base HTTPS URL
	local user, repo = remote:match("git@[^:]+:([^/]+)/(.+)$")
	local base
	if user and repo then
		base = ("https://github.com/%s/%s"):format(user, repo:gsub("%.git$", ""))
	else
		base = remote:match("https://[^%s]+"):gsub("%.git$", "")
	end

	if not base then
		vim.notify("Unsupported remote URL: " .. remote, vim.log.levels.WARN)
		return
	end

	local rel = file:sub(#root + 2)
	local fragment = (end_line and end_line ~= start_line) and ("#L%d-L%d"):format(start_line, end_line)
		or ("#L%d"):format(start_line)

	return ("%s/blob/%s/%s%s"):format(base, sha, rel, fragment)
end

-- GitHub dark-mode diff colors
function M.set_diff_highlights()
	vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#1a382e" })
	vim.api.nvim_set_hl(0, "DiffChange", { bg = "#204c30" })
	vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#471920" })
	vim.api.nvim_set_hl(0, "DiffText", { bg = "#204c31" })
	vim.api.nvim_set_hl(0, "GitSignsAddLn", { bg = "#1a382e" })
	vim.api.nvim_set_hl(0, "GitSignsChangeLn", { bg = "#1a382e" })
	vim.api.nvim_set_hl(0, "GitSignsDeleteLn", { bg = "#471920" })
	vim.api.nvim_set_hl(0, "GitSignsAddInline", { bg = "#204c31" })
	vim.api.nvim_set_hl(0, "GitSignsChangeInline", { bg = "#204c31" })
	vim.api.nvim_set_hl(0, "GitSignsDeleteInline", { bg = "#5b2026" })
	vim.api.nvim_set_hl(0, "GitSignsAddLnInline", { bg = "#204c31" })
	vim.api.nvim_set_hl(0, "GitSignsChangeLnInline", { bg = "#204c31" })
	vim.api.nvim_set_hl(0, "GitSignsDeleteLnInline", { bg = "#5b2026" })
end

return M
