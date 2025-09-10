    return {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("overrides.configs.nvim-lint")
        end,
    }
