local linters_by_language = require "overrides.mason.linters"

local linters = {}
for language, v in pairs(linters_by_language) do
    for _, linter in ipairs(v) do
            table.insert(linters, linter)
    end
end

require("mason-nvim-lint").setup({
    ensure_installed = linters,
    automatic_installation = false,
})
