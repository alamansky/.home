--  https://github.com/stevearc/conform.nvim?tab=readme-ov-file#formatters

local js_formatter = "prettier"

return {
	lua = { "stylua" },
	-- custom
	yaml = { "yamlfmt" },
	-- css = { "prettier" },
	-- html = { "prettier" },
	javascript = { js_formatter },
	typescript = { js_formatter },
	javascriptreact = { js_formatter },
	typescriptreact = { js_formatter },
	json = { js_formatter },
}
