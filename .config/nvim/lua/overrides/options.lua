-- always write newline to end of file
vim.opt.fixeol = true

-- use absolute number for current line and relative line numbers for above/below
vim.wo.number = true
vim.wo.relativenumber = true

-- create folds on indent and open to specified depth
vim.opt.foldmethod = "indent"
vim.opt.foldlevelstart = 99

-- clipboard integration for clipipe
vim.opt.clipboard = "unnamedplus"

-- read live file changes from disk
vim.opt.autoread = true
