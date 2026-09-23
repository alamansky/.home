-- always write newline to end of file
vim.opt.fixeol = true

-- use absolute number for current line and relative line numbers for above/below
vim.wo.number = true
vim.wo.relativenumber = true

-- create folds on indent and open to specified depth
vim.opt.foldmethod = "indent"
vim.opt.foldlevelstart = 99

-- also apply to new terminals
vim.api.nvim_create_autocmd("TermOpen", {
	callback = function()
		vim.opt_local.number = true
		vim.opt_local.relativenumber = true
		-- do not open other buffers in a terminal window
		vim.opt_local.winfixbuf = true
	end,
	group = vim.api.nvim_create_augroup("TerminalRelativeNumbers", { clear = true }),
})

-- clipboard integration for clipipe
vim.opt.clipboard = "unnamedplus"

-- read live file changes from disk
vim.opt.autoread = true

-- open nvim in directory given as arg
-- https://github.com/NvChad/NvChad/issues/316
-- (replaced BufEnter with VimEnter to avoid changing telescope behavior)
vim.cmd([[ autocmd VimEnter * if &buftype != "terminal" | lcd %:p:h | endif ]])

-- open nvim-tree on startup
vim.api.nvim_create_autocmd("VimEnter", {
	pattern = { "*" },
	callback = function()
		-- only build the startup layout on a bare launch (no file args)
		--if vim.fn.argc() > 0 then
		--  return
		--end
		require("nvim-tree.api").tree.open()
	end,
})

-- add relative motions to jump list
vim.keymap.set({ "n", "x" }, "j", function()
	return vim.v.count > 1 and "m'" .. vim.v.count .. "j" or "j"
end, { noremap = true, expr = true })

vim.keymap.set({ "n", "x" }, "k", function()
	return vim.v.count > 1 and "m'" .. vim.v.count .. "k" or "k"
end, { noremap = true, expr = true })

-- move buffer left
vim.keymap.set({ "n", "x" }, "th", function()
	return require("nvchad.tabufline").move_buf(-1)
end, { noremap = true, expr = true })

-- move buffer right
vim.keymap.set({ "n", "x" }, "tl", function()
	return require("nvchad.tabufline").move_buf(1)
end, { noremap = true, expr = true })

-- move buffer to first
vim.keymap.set({ "n", "x" }, "tt", function()
	local bufs = vim.t.bufs
	for i, bufnr in ipairs(bufs) do
		if bufnr == vim.api.nvim_win_get_buf(0) then
			local tmp = bufnr
			table.remove(bufs, i)
			table.insert(bufs, 1, tmp)
			break
		end
	end
	vim.t.bufs = bufs
	return vim.cmd("redrawtabline")
end, { noremap = true, expr = true })

-- telescope shortcuts (TODO - move into seperate config file)

-- pick from open buffers
vim.api.nvim_set_keymap(
	"n",
	"<leader>fb",
	':lua require("telescope.builtin").buffers()<CR>',
	{ noremap = true, silent = true }
)

-- pick from treesitter
vim.api.nvim_set_keymap(
	"n",
	"<leader>ft",
	':lua require("telescope.builtin").treesitter()<CR>',
	{ noremap = true, silent = true }
)

-- pick from modified repo files
vim.api.nvim_set_keymap(
	"n",
	"<leader>fg",
	':lua require("telescope.builtin").git_status()<CR>',
	{ noremap = true, silent = true }
)

-- pick from registers
vim.api.nvim_set_keymap(
	"n",
	"<leader>fr",
	':lua require("telescope.builtin").registers()<CR>',
	{ noremap = true, silent = true }
)

-- pick from quickfix list
vim.api.nvim_set_keymap(
	"n",
	"<leader>fq",
	':lua require("telescope.builtin").quickfix()<CR>',
	{ noremap = true, silent = true }
)
-- pick from jumplist
vim.api.nvim_set_keymap(
	"n",
	"<leader>fj",
	':lua require("telescope.builtin").jumplist()<CR>',
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap("n", "<leader>dr", ":lua require('dap').repl.open()<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>df", '<cmd>lua require("jdtls").test_class()<CR>')
vim.keymap.set("n", "<leader>dn", '<cmd>lua require("jdtls").test_nearest_method()<CR>')

vim.keymap.set(
	"n",
	"<leader>ht",
	"<cmd>Gitsigns toggle_linehl<cr><cmd>Gitsigns toggle_deleted<cr><cmd>Gitsigns toggle_word_diff<cr>"
)

-- https://github.com/bcampolo/nvim-starter-kit/blob/main/.config/nvim/lua/core/keymaps.lua
local keymap = vim.keymap
keymap.set("n", "<leader>gg", "<cmd>lua vim.lsp.buf.hover()<CR>")
keymap.set("n", "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
keymap.set("n", "<leader>gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
keymap.set("n", "<leader>gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
keymap.set("n", "<leader>gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
keymap.set("n", "<leader>gr", "<cmd>lua vim.lsp.buf.references()<CR>")
keymap.set("n", "<leader>gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
keymap.set("n", "<leader>rr", "<cmd>lua vim.lsp.buf.rename()<CR>")
keymap.set("n", "<leader>gf", "<cmd>lua vim.lsp.buf.format({async = true})<CR>")
keymap.set("v", "<leader>gf", "<cmd>lua vim.lsp.buf.format({async = true})<CR>")
keymap.set("n", "<leader>ga", "<cmd>lua vim.lsp.buf.code_action()<CR>")
keymap.set("n", "<leader>gl", "<cmd>lua vim.diagnostic.open_float()<CR>")
keymap.set("n", "<leader>gp", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
keymap.set("n", "<leader>gn", "<cmd>lua vim.diagnostic.goto_next()<CR>")
keymap.set("n", "<leader>tr", "<cmd>lua vim.lsp.buf.document_symbol()<CR>")
--keymap.set('i', '<C-Space>', '<cmd>lua vim.lsp.buf.completion()<CR>')

-- window resizing
vim.api.nvim_create_user_command("HResize", function(opt)
	local percentage = tonumber(opt.args)
	if percentage then
		vim.cmd("vertical resize " .. tostring(math.floor(vim.opt.columns:get() * (percentage / 100))))
	else
		print("Invalid percentage")
	end
end, { nargs = 1 })
keymap.set("n", "<leader>rh", ":HResize ")

vim.api.nvim_create_user_command("VResize", function(opt)
	local percentage = tonumber(opt.args)
	if percentage then
		vim.cmd("horizontal resize " .. tostring(math.floor(vim.opt.lines:get() * (percentage / 100))))
	else
		print("Invalid percentage")
	end
end, { nargs = 1 })
keymap.set("n", "<leader>rv", ":VResize ")

-- yank relative file path and current line number to system register
keymap.set("n", "<leader>rl", function()
	vim.fn.setreg("+", vim.fn.expand("%") .. ":" .. vim.fn.line("."))
end)

-- yank relative file path and visual selection line range to system register
keymap.set("v", "<leader>rs", function()
	local start_line = vim.fn.line("v")
	local end_line = vim.fn.line(".")
	if start_line > end_line then
		start_line, end_line = end_line, start_line
	end
	vim.fn.setreg("+", vim.fn.expand("%") .. ":" .. start_line .. "-" .. end_line)
end)

-- yank GitHub permalink for the current line or visual selection
local function github_url(start_line, end_line)
	local file = vim.api.nvim_buf_get_name(0)
	if file == "" then
		vim.notify("Buffer has no file path", vim.log.levels.WARN)
		return
	end

	local function sh(cmd)
		local out = vim.fn.system(cmd)
		if vim.v.shell_error ~= 0 then return nil end
		return vim.trim(out)
	end

	local root = sh "git rev-parse --show-toplevel"
	if not root then
		vim.notify("Not inside a git repo", vim.log.levels.WARN)
		return
	end

	local sha = sh "git rev-parse HEAD"
	local remote = sh "git remote get-url origin"
	if not sha or not remote then
		vim.notify("Could not read git metadata", vim.log.levels.WARN)
		return
	end

	-- Convert SSH (including custom host aliases) or HTTPS remote to base HTTPS URL
	local user, repo = remote:match "git@[^:]+:([^/]+)/(.+)$"
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
	local fragment = (end_line and end_line ~= start_line)
		and ("#L%d-L%d"):format(start_line, end_line)
		or ("#L%d"):format(start_line)

	return ("%s/blob/%s/%s%s"):format(base, sha, rel, fragment)
end

keymap.set("n", "<leader>rg", function()
	local url = github_url(vim.fn.line ".")
	if url then
		vim.fn.setreg("+", url)
		vim.notify("Copied: " .. url)
	end
end, { desc = "Yank GitHub permalink for current line" })

keymap.set("v", "<leader>rg", function()
	local s = vim.fn.line "v"
	local e = vim.fn.line "."
	if s > e then s, e = e, s end
	local url = github_url(s, e)
	if url then
		vim.fn.setreg("+", url)
		vim.notify("Copied: " .. url)
	end
end, { desc = "Yank GitHub permalink for visual selection" })
