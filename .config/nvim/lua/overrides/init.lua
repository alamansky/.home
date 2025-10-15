-- use absolute number for current line and relative line numbers for above/below
vim.wo.number = true
vim.wo.relativenumber = true
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
