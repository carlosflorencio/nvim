return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{
				"rcarriga/nvim-dap-ui",
				config = function()
					require("dapui").setup({
						layouts = {
							{
								elements = {
									{ id = "scopes", size = 0.8 },
									-- { id = "breakpoints", size = 0.25 },
									-- { id = "stacks", size = 0.25 },
									{ id = "watches", size = 0.2 },
								},
								position = "right",
								size = 50,
							},
							{
								elements = {
									{ id = "console", size = 0.5 },
									{ id = "repl", size = 0.5 },
								},
								position = "bottom",
								size = 10,
							},
						},
					})
				end,
				keys = {
					{ ",U", "<cmd>lua require('dapui').toggle()<CR>", "Toggle DAP UI" },
					{ ",C", "<cmd>lua require('dapui').close()<CR>", "Close DAP UI" },
				},
			},
			"mxsdev/nvim-dap-vscode-js",
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
						request = "attach",
						name = "Attach",
						processId = require("dap.utils").pick_process,
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

			-- auto open dap ui
			dap.listeners.after.event_initialized["dapui_config"] = function()
				require("dapui").open()
			end
			-- auto close dap ui
			dap.listeners.before.event_terminated["dapui_config"] = function()
				require("dapui").close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				require("dapui").close()
			end

			--icons
			local user_icons = require("user.ui").icons
			vim.fn.sign_define("DapBreakpoint", {
				text = user_icons.ui.Bug,
				texthl = "DiagnosticSignError",
				linehl = "",
				numhl = "",
			})
			vim.fn.sign_define("DapBreakpointRejected", {
				text = user_icons.ui.Bug,
				texthl = "DiagnosticSignError",
				linehl = "",
				numhl = "",
			})
			vim.fn.sign_define("DapStopped", {
				text = user_icons.ui.BoldArrowRight,
				texthl = "DiagnosticSignWarn",
				linehl = "Visual",
				numhl = "DiagnosticSignWarn",
			})
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
		dependencies = { "mfussenegger/nvim-dap", "microsoft/vscode-js-debug" },
		opts = {
			-- fix sourcemaps console errors https://github.com/mxsdev/nvim-dap-vscode-js/issues/35
			adapters = { "pwa-node", "node-terminal" },
			debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
		},
	},

	{
		"Weissle/persistent-breakpoints.nvim",
		event = "BufReadPost",
		opts = {
			load_breakpoints_event = { "BufReadPost" },
		},
		keys = {
			{
				",bb",
				"<cmd>lua require('persistent-breakpoints.api').toggle_breakpoint()<CR>",
				"Toggle breakpoint",
			},
			{
				",bc",
				"<cmd>lua require('persistent-breakpoints.api').set_conditional_breakpoint()<CR>",
				"Conditional breakpoint",
			},
			{
				",bd",
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
