local lsps = require "overrides.mason.lsps"

require("mason-lspconfig").setup({
    ensure_installed = lsps,
    automatic_installation = false,
})
