local mini_map = require("mini.map")

mini_map.setup({
	-- Highlight integrations (none by default)
	integrations = {
		mini_map.gen_integration.builtin_search(),
		mini_map.gen_integration.diff(),
		mini_map.gen_integration.diagnostic(),
	},

	-- Symbols used to display data
	symbols = {
		-- Encode symbols. See `:h MiniMap.config` for specification and
		-- `:h MiniMap.gen_encode_symbols` for pre-built ones.
		-- Default: solid blocks with 3x2 resolution.
		encode = mini_map.gen_encode_symbols.dot("4x2"),

		-- Scrollbar parts for view and line. Use empty string to disable any.
		scroll_line = "█",
		scroll_view = "┃",
	},

	-- Window options
	window = {
		-- Whether window is focusable in normal way (with `wincmd` or mouse)
		focusable = false,

		-- Side to stick ('left' or 'right')
		side = "right",

		-- Whether to show count of multiple integration highlights
		show_integration_count = true,

		-- Total width
		width = 10,

		-- Value of 'winblend' option
		winblend = 25,

		-- Z-index
		zindex = 10,
	},
})

vim.keymap.set("n", "<Leader>mc", MiniMap.close)
vim.keymap.set("n", "<Leader>mf", MiniMap.toggle_focus)
vim.keymap.set("n", "<Leader>mo", MiniMap.open)
vim.keymap.set("n", "<Leader>mr", MiniMap.refresh)
vim.keymap.set("n", "<Leader>ms", MiniMap.toggle_side)
vim.keymap.set("n", "<Leader>mt", MiniMap.toggle)
