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

-- open nvim in directory given as arg
-- https://github.com/NvChad/NvChad/issues/316
-- (replaced BufEnter with VimEnter to avoid changing telescope behavior)
vim.cmd([[ autocmd VimEnter * if &buftype != "terminal" | lcd %:p:h | endif ]])

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
