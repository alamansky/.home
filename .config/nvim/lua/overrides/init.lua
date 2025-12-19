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
	end,
	group = vim.api.nvim_create_augroup("TerminalRelativeNumbers", { clear = true }),
})

-- clipboard integration for clipipe
vim.opt.clipboard = "unnamedplus"

-- open nvim in directory given as arg
-- https://github.com/NvChad/NvChad/issues/316
-- (replaced BufEnter with VimEnter to avoid changing telescope behavior)
vim.cmd([[ autocmd VimEnter * if &buftype != "terminal" | lcd %:p:h | endif ]])

-- open nvim-tree on startup
vim.api.nvim_create_autocmd("VimEnter", {
	pattern = { "*" },
	callback = function()
		--if #vim.api.nvim_list_args() == 0 then -- No file specified
		require("nvim-tree.api").tree.open()
		--end
	end,
})

-- add relative motions to jump list
vim.keymap.set({ "n", "x" }, "j", function()
	return vim.v.count > 1 and "m'" .. vim.v.count .. "j" or "j"
end, { noremap = true, expr = true })

vim.keymap.set({ "n", "x" }, "k", function()
	return vim.v.count > 1 and "m'" .. vim.v.count .. "k" or "k"
end, { noremap = true, expr = true })

-- shortcuts to re-order buffer list

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
