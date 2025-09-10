local options = {
  formatters_by_ft = require "overrides.mason.formatters", 

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
