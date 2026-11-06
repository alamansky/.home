local keymap = vim.keymap
local git = require("overrides.functions.git")
local sql = require("overrides.functions.sql")
local cx = require("overrides.functions.cx")

-- fold
keymap.set("n", "<leader>zz", function()
	vim.opt.foldlevel = vim.fn.foldlevel(vim.fn.line("."))
end, { desc = "Set foldlevel to current line fold depth" })

-- add relative motions to jump list
keymap.set({ "n", "x" }, "j", function()
	return vim.v.count > 1 and "m'" .. vim.v.count .. "j" or "j"
end, { noremap = true, expr = true })

keymap.set({ "n", "x" }, "k", function()
	return vim.v.count > 1 and "m'" .. vim.v.count .. "k" or "k"
end, { noremap = true, expr = true })

-- move buffer left
keymap.set({ "n", "x" }, "th", function()
	return require("nvchad.tabufline").move_buf(-1)
end, { noremap = true, expr = true })

-- move buffer right
keymap.set({ "n", "x" }, "tl", function()
	return require("nvchad.tabufline").move_buf(1)
end, { noremap = true, expr = true })

-- move buffer to first
keymap.set({ "n", "x" }, "tt", function()
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

-- telescope
-- pick from open buffers
keymap.set("n", "<leader>fb", function()
	require("telescope.builtin").buffers()
end)
-- pick from treesitter
keymap.set("n", "<leader>ft", function()
	require("telescope.builtin").treesitter()
end)
-- pick from modified repo files
keymap.set("n", "<leader>fg", function()
	require("telescope.builtin").git_status()
end)
-- pick from registers
keymap.set("n", "<leader>fr", function()
	require("telescope.builtin").registers()
end)
-- pick from quickfix list
keymap.set("n", "<leader>fq", function()
	require("telescope.builtin").quickfix()
end)
-- pick from jumplist
keymap.set("n", "<leader>fj", function()
	require("telescope.builtin").jumplist()
end)

-- DAP
keymap.set("n", "<leader>dr", function()
	require("dap").repl.open()
end)
keymap.set("n", "<leader>df", function()
	require("jdtls").test_class()
end)
keymap.set("n", "<leader>dn", function()
	require("jdtls").test_nearest_method()
end)

-- LSP
-- https://github.com/bcampolo/nvim-starter-kit/blob/main/.config/nvim/lua/core/keymaps.lua
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
keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to Implementation" })

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

-- GitHub permalink
keymap.set("n", "<leader>rg", function()
	local url = git.github_url(vim.fn.line("."))
	if url then
		vim.fn.setreg("+", url)
		vim.notify("Copied: " .. url)
	end
end, { desc = "Yank GitHub permalink for current line" })

keymap.set("v", "<leader>rg", function()
	local s = vim.fn.line("v")
	local e = vim.fn.line(".")
	if s > e then
		s, e = e, s
	end
	local url = git.github_url(s, e)
	if url then
		vim.fn.setreg("+", url)
		vim.notify("Copied: " .. url)
	end
end, { desc = "Yank GitHub permalink for visual selection" })

-- SQL
keymap.set(
	{ "n", "v" },
	"<leader>db",
	sql.run_query,
	{ desc = "Run visual SQL selection (or current line) against usql connection matched from filename" }
)
keymap.set("n", "<leader>tj", sql.csv_to_json, { desc = "Convert connection CSV output to JSON via qq" })

-- Coralogix
keymap.set(
	{ "n", "v" },
	"<leader>cx",
	cx.run_cx_logs,
	{ desc = "Run visual DataPrime selection (or current line) via cx logs, save to output/<stem>.json" }
)

-- mini-map
keymap.set("n", "<Leader>mc", MiniMap.close)
keymap.set("n", "<Leader>mf", MiniMap.toggle_focus)
keymap.set("n", "<Leader>mo", MiniMap.open)
keymap.set("n", "<Leader>mr", MiniMap.refresh)
keymap.set("n", "<Leader>ms", MiniMap.toggle_side)
keymap.set("n", "<Leader>mt", MiniMap.toggle)

-- diagnostics
keymap.set("n", "<leader>dv", function()
	local current_config = vim.diagnostic.config().virtual_text
	vim.diagnostic.config({ virtual_text = not current_config })
end, { desc = "Toggle diagnostic virtual text" })

-- =============================================================================
-- Reference: shortcuts not bound above
-- =============================================================================
--
-- Standard neovim
--   <C-e>              close autocomplete
--   .                  repeat last command
--   *                  add word under cursor to search registry
--
-- Commands
--   :qa                quit all open buffers
--   :set filetype?     check file type of current buffer
--   :f                 display file path relative to root project directory
--   :%s/find/replace/g find and replace all instances in current buffer
--   :grep              search with grep, send results to quickfix list
--
-- Editing
--   s                  delete char and insert
--   S                  delete line and insert
--   C                  delete until end of line and insert
--   u                  undo changes
--   <C-r>              redo changes
--
-- Text objects
--   p                  paragraph
--   w                  word
--   s                  sentence
--   [, (, {, <         block delimiter
--   ', ", `            quote delimiter
--   t                  tag
--
-- Paging
--   <C-b>              scroll up one full page
--   <C-f>              scroll down one full page
--   <C-u>              scroll up half a page
--   <C-d>              scroll down half a page
--   0gg                go to 0th (nth) line number
--   gg                 scroll to first line
--   G                  scroll to last line
--   zz                 scroll current line to center
--   zt                 scroll current line to top of page
--   zb                 scroll current line to bottom of page
--
-- Windows
--   <C-w>              move current window (e.g. <C-w>L to far right)
--   <C-w>s             new horizontal split
--   <C-w>v             new vertical split
--   <C-w>c             close active split
--
-- Motions
--   H                  first line in view
--   M                  middle line in view
--   L                  last line of view
--   e                  end of word
--   ge                 end of previous word
--   0                  start of line
--   ^                  start of line (after whitespace)
--   $                  end of line
--   f{c}               forward to character {c} on line
--   F{c}               backward to character {c} on line
--   t{c}               forward to before character {c}
--   T{c}               forward to after character {c}
--   %                  nearest bracket
--   [m                 previous method start
--   [M                 previous method end
--
-- Navigation
--   gf                 go to file under cursor
--   gx                 go to link under cursor
--   gd                 go to method definition
--   <C-O>              go back through jump history
--   <C-I>              go forward through jump history
--
-- Marks
--   :marks             list marks
--   `                  list marks
--   m{c}               set mark {c}
--   `{c}               go to mark {c}
--   `.                 go to last change
--
-- Folds
--   za                 toggle fold
--   zm                 increase fold depth by 1
--   zr                 decrease fold depth by 1
--   zM                 close all folds
--   zR                 open all folds
--   zc                 close fold
--   zo                 open fold
--
-- Macros
--   q{r}{macro}q       record macro into register {r}
--   @{r}               replay macro from register {r}
--
-- Registers
--   "                  view all registers
--   "0                 last yanked content (e.g. "0p to paste)
--   "_                 blackhole register (e.g. "_d to delete without saving)
--
-- Quickfix list
--   :cw                open quickfix window
--   :set modifiable    allow vim motions on the list
--
-- NvChad
--   <leader>rn         toggle relative line numbers
--   <leader>ra         rename symbol
--
-- Nvim-Tree
--   r                  rename file
--   d                  delete file
--   y                  copy file name
--   c                  copy file
--   p                  paste file
--   <C-k>              show file info (path, size, timestamps)
--
-- Telescope
--   <leader>ff         find source files (excluding node_modules etc)
--   <leader>fa         find all files
--   <leader>fw         find in files (live grep)
--   <Tab>              toggle selection and move to next
--   <S-Tab>            toggle selection and move to prev
--   <M-q>              send selected items to quickfix list
--
-- Tabufline
--   gt                 go to next tab
--   gT                 go to previous tab
--   1gt                go to tab by index
--   <C-w>T             open current buffer in new tab
--   :tabnew {path}     open new tab
--   :tcd {path}        set tab working directory
--   :tabclose {index}  close tab at index
--
-- Override mappings
--   :Pencil            enter prose writing mode
--   <leader>xx         toggle diagnostics panel
--
-- nvim-dap
--   <leader>d          toggle breakpoint
--   <leader>n          step over
--   <leader>i          step into
--   <leader>o          step out
--   <leader>c          start debug session
--   <leader>dt         toggle dap-ui elements
--   <leader>de         evaluate expression in hover window
--   e                  edit            (dap-ui window)
--   <CR>               expand          (dap-ui window)
--   o                  open            (dap-ui window)
--   d                  remove          (dap-ui window)
--   r                  repl            (dap-ui window)
--   t                  toggle          (dap-ui window)
--
-- gitsigns
--   ]c                 go to next hunk
--   [c                 go to previous hunk
--   <leader>hs         stage hunk
--   <leader>hr         unstage/reset hunk
--   <leader>hS         stage buffer (git add {filename})
--   <leader>hR         reset buffer (git restore --staged {filename})
--   <leader>hp         preview hunk
--   <leader>hi         preview hunk inline
--   <leader>hb         blame current line (full)
--   <leader>hd         diff current file
--   <leader>hq         send hunks to quickfix list
--   <leader>tb         toggle current line blame
--   <leader>tw         toggle word diff
--   ih                 "in hunk" text object
--   <C-w>q             exit diff window
--
-- forgit
--   <Tab>              toggle mark and move down
--   <S-Tab>            toggle mark and move up
--   <M-w>              toggle text wrap in preview window
--   <C-j> / <C-k>      scroll list up / down
--   <M-j> / <M-k>      scroll preview window up / down
--
-- Key guide: CR=enter  C=control  S=shift  M=alt
