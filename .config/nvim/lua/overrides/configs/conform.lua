local options = {
	formatters_by_ft = require("overrides.mason.formatters"),

	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 2000,
		-- uncomment to use LSP for formatting (conflicts with eslint/prettier)
		--lsp_fallback = true,
	},
}

return options
