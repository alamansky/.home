return {
	"YouSame2/inlinediff-nvim",
	lazy = true, -- disable loading plugin until called with cmd or keys
	cmd = "InlineDiff",
	opts = {
		debounce_time = 200,
		ignored_buftype = { "terminal", "nofile" },
		ignored_filetype = { "TelescopePrompt", "NvimTree", "neo-tree" },
		colors = {
			-- context = dim background color; change = bright background color for changed text.
			InlineDiffAddContext = "#0d1f00",
			InlineDiffAddChange = "#1e4d00",
			InlineDiffDeleteContext = "#3d0010",
			InlineDiffDeleteChange = "#4d0014",
		},
	}, -- leave blank to use defaults
	config = function(_, opts)
		require("inlinediff").setup(opts)
		local function apply_highlights()
			vim.api.nvim_set_hl(0, "InlineDiffAddContext",    { bg = "#0d1f00", nocombine = true })
			vim.api.nvim_set_hl(0, "InlineDiffAddChange",     { bg = "#1e4d00", nocombine = true })
			vim.api.nvim_set_hl(0, "InlineDiffDeleteContext", { bg = "#3d0010", nocombine = true })
			vim.api.nvim_set_hl(0, "InlineDiffDeleteChange",  { bg = "#4d0014", nocombine = true })
		end
		apply_highlights()
		vim.api.nvim_create_autocmd("ColorScheme", { callback = apply_highlights })
	end,
	keys = {
		{
			"<leader>ht",
			function()
				require("inlinediff").toggle()
			end,
			desc = "Toggle inline diff",
		},
	},
}
