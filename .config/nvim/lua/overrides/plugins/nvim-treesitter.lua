return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "OXY2DEV/markview.nvim" }, --load markview before treesitter
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require "overrides.configs.nvim-treesitter"
    end,
  },
}
