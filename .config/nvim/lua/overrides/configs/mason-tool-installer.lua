local tools = require("overrides.mason.tools")

require("mason-tool-installer").setup({
	ensure_installed = tools,
})
