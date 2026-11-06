-- Tab renaming: :TabRename <name> pins a display name; :TabRename clears it back to auto (cwd)
vim.api.nvim_create_user_command("TabRename", function(opts)
	if opts.args ~= "" then
		vim.t.tabname = opts.args
		vim.t.tabname_pinned = true
	else
		vim.t.tabname = nil
		vim.t.tabname_pinned = nil
	end
	vim.cmd("redrawtabline")
end, { nargs = "?" })

vim.api.nvim_create_autocmd({ "VimEnter", "TabNew", "DirChanged" }, {
	callback = function()
		if not vim.t.tabname_pinned then
			vim.t.tabname = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
			vim.cmd("redrawtabline")
		end
	end,
})

vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		local ok, nvconfig = pcall(require, "nvconfig")
		if not ok then
			return
		end
		local btn = require("nvchad.tabufline.utils").btn
		local fn = vim.fn
		local tabufline_opts = nvconfig.ui.tabufline
		tabufline_opts.modules = tabufline_opts.modules or {}
		tabufline_opts.modules.tabs = function()
			local result, total_tabs = "", fn.tabpagenr("$")
			if total_tabs > 1 then
				for nr = 1, total_tabs do
					local tp = vim.api.nvim_list_tabpages()[nr]
					local name_ok, name = pcall(vim.api.nvim_tabpage_get_var, tp, "tabname")
					local base = name_ok and name
					local label = base and (nr .. "|" .. base) or tostring(nr)
					local tab_hl = "TabO" .. (nr == fn.tabpagenr() and "n" or "ff")
					result = result .. btn(" " .. label .. " ", tab_hl, "GotoTab", nr)
				end
				local new_tabtn = btn(" 󰐕 ", "TabNewBtn", "NewTab")
				local tabstoggleBtn = btn(" TABS ", "TabTitle", "ToggleTabs")
				local small_btn = btn(" 󰅁 ", "TabTitle", "ToggleTabs")
				return vim.g.TbTabsToggled == 1 and small_btn or new_tabtn .. tabstoggleBtn .. result
			end
			return ""
		end
	end,
})
