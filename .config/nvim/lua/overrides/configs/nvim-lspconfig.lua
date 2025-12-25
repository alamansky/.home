require("nvchad.configs.lspconfig").defaults()

local servers = require("overrides.mason.lsps")

require("overrides.lsp.jdtls") -- configure java lsp

vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
