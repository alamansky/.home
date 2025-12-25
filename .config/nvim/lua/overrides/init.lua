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

-- pick from registers
vim.api.nvim_set_keymap(
	"n",
	"<leader>fr",
	':lua require("telescope.builtin").registers()<CR>',
	{ noremap = true, silent = true }
)

vim.api.nvim_set_keymap("n", "<leader>dr", ":lua require('dap').repl.open()<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>df", '<cmd>lua require("jdtls").test_class()<CR>')
vim.keymap.set("n", "<leader>dn", '<cmd>lua require("jdtls").test_nearest_method()<CR>')

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
