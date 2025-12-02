return {
	"mfussenegger/nvim-dap",
	dependencies = (function()
		local deps = require("overrides.mason.debuggers")
		table.insert(deps, 1, "nvim-neotest/nvim-nio")
		table.insert(deps, 1, "rcarriga/nvim-dap-ui")
		return deps
	end)(),
	keys = {
		-- normal mode is default
		{
			"<leader>d",
			function()
				require("dap").toggle_breakpoint()
			end,
		},
		{
			"<leader>c",
			function()
				require("dap").continue()
			end,
		},
		{
			"<leader>n",
			function()
				require("dap").step_over()
			end,
		},
		{
			"<leader>i",
			function()
				require("dap").step_into()
			end,
		},
		{
			"<leader>o",
			function()
				require("dap").step_out()
			end,
		},
	},
	config = function()
		require("overrides.configs.nvim-dap")
	end,
}
