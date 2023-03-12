return {
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = function()
			local components = require("user.plugins.lualine.components")
			local package_info = require("package-info")
			-- local utils = require("user.plugins.lualine.utils")
			require("user.plugins.lualine.wakatime")

			--components.branch.fmt = utils.trunc(30)
			return {
				options = {
					theme = "auto",
					globalstatus = true,
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = {
						statusline = { "dashboard", "lazy", "alpha" },
					},
				},
				sections = {
					lualine_b = { components.branch },
					lualine_c = {
						"lsp_progress",
						package_info.get_status,
						require("recorder").recordingStatus,
						components.python_env,
					},
					lualine_x = { components.lsp, components.filetype, "searchcount", Lualine_get_wakatime },
					lualine_y = { "overseer", components.diagnostics },
					lualine_z = {},
				},
				extensions = {},
			}
		end,
	},
	{
		-- statuslune lsp progress
		"arkav/lualine-lsp-progress",
	},
}
