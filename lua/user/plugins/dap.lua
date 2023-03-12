return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{
				"rcarriga/nvim-dap-ui",
				config = function()
					require("dapui").setup()
				end,
				keys = {
					{ ",U", "<cmd>lua require('dapui').toggle()<CR>", "Toggle DAP UI" },
					{ ",C", "<cmd>lua require('dapui').close()<CR>", "Close DAP UI" },
				},
			},
			{ "jbyuki/one-small-step-for-vimkind" },
		},
		config = function()
			local dap = require("dap")

			for _, language in ipairs({ "javascript", "javascriptreact" }) do
				dap.configurations[language] = {
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch file",
						program = "${file}",
						cwd = "${workspaceFolder}",
					},
					{
						type = "pwa-node",
						request = "launch",
						name = "Debug Jest Tests",
						-- trace = true, -- include debugger info
						runtimeExecutable = "node",
						runtimeArgs = {
							"./node_modules/jest/bin/jest.js",
							"--runInBand",
						},
						rootPath = "${workspaceFolder}",
						cwd = "${workspaceFolder}",
						console = "integratedTerminal",
						internalConsoleOptions = "neverOpen",
					},
				}
			end

			for _, language in ipairs({ "typescript", "typescriptreact" }) do
				dap.configurations[language] = {
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch file Typescript",
						program = "${file}",
						cwd = "${workspaceFolder}",
						runtimeExecutable = "ts-node",
					},
					{
						type = "pwa-node",
						request = "launch",
						name = "Debug Jest Tests",
						-- trace = true, -- include debugger info
						runtimeExecutable = "node",
						runtimeArgs = {
							"./node_modules/jest/bin/jest.js",
							"--runInBand",
						},
						rootPath = "${workspaceFolder}",
						cwd = "${workspaceFolder}",
						console = "integratedTerminal",
						internalConsoleOptions = "neverOpen",
					},
				}
			end

			-- auto close dap ui
			dap.listeners.before.event_terminated["dapui_config"] = function()
				require("dapui").close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				require("dapui").close()
			end
		end,
	},

	{
		-- vscode debug adapter install
		"microsoft/vscode-js-debug",
		build = "npm install --legacy-peer-deps && npm run compile",
		-- https://github.com/mxsdev/nvim-dap-vscode-js/issues/23
		tag = "v1.74.1",
	},

	{
		-- dap adapter for the newer vscode-js debugger
		"mxsdev/nvim-dap-vscode-js",
		dependencies = { "mfussenegger/nvim-dap" },
		opts = {
			-- TODO: fix wrong vim.fn.stdpath("data") paths because of lvim
			debugger_path = vim.fn.expand("~/.local/share/lunarvim/site/pack/packer/opt/vscode-js-debug"),
			adapters = { "pwa-node", "node-terminal" },
		},
	},

	{
		"Weissle/persistent-breakpoints.nvim",
		opts = {
			load_breakpoints_event = { "BufReadPost" },
		},
		keys = {
			{
				"<leader>bb",
				"<cmd>lua require('persistent-breakpoints.api').toggle_breakpoint()<CR>",
				"Toggle breakpoint",
			},
			{
				"<leader>bc",
				"<cmd>lua require('persistent-breakpoints.api').set_conditional_breakpoint()<CR>",
				"Conditional breakpoint",
			},
			{
				"<leader>bd",
				"<cmd>lua require('persistent-breakpoints.api').clear_all_breakpoints()<cr>",
				"Delete all breakpoints",
			},
		},
	},

	{
		"ofirgall/goto-breakpoints.nvim",
		keys = {
			{
				"]b",
				function()
					require("goto-breakpoints").next()
				end,
				"Next breakpoint",
			},
			{
				"[b",
				function()
					require("goto-breakpoints").prev()
				end,
				"Previous breakpoint",
			},
		},
	},

	{
		"theHamsta/nvim-dap-virtual-text",
		opts = {},
	},
}
