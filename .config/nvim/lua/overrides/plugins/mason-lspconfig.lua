 return   {
        "williamboman/mason-lspconfig.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-lspconfig" },
        config = function()
            require("overrides.configs.mason-lspconfig")
        end,
    }
