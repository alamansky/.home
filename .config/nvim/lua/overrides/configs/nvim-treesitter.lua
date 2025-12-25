-- extends $XDG_DATA_HOME/nvim/lazy/NvChad/lua/nvchad/configs/treesitter.lua
local options = {
	ensure_installed = {
		-- nvchad
		"lua",
		"luadoc",
		"printf",
		"vim",
		"vimdoc",
		-- custom
		"bash",
		"javascript",
		"yaml",
		"java",
	},

	highlight = {
		enable = true,
		use_languagetree = true,
	},

	indent = { enable = true },
}

require("nvim-treesitter.configs").setup(options)
