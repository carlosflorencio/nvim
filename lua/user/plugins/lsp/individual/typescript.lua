return {
	{
		-- add typescript to treesitter
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, { "typescript", "tsx" })
			end
		end,
	},

	{
		"neovim/nvim-lspconfig",
		dependencies = { "jose-elias-alvarez/typescript.nvim" },
		opts = {
			-- make sure mason installs the server
			servers = {
				---@type lspconfig.options.tsserver
				tsserver = {
					settings = {
						completions = {
							completeFunctionCalls = true,
						},
					},
				},
			},
			setup = {
				tsserver = function(_, opts)
					require("user.util").on_attach(function(client, buffer)
						if client.name == "tsserver" then
							vim.keymap.set(
								"n",
								"<leader>oi",
								"<cmd>TypescriptOrganizeImports<CR>",
								{ buffer = buffer, desc = "Organize Imports" }
							)
							vim.keymap.set(
								"n",
								"<leader>oa",
								"<cmd>TypescriptAddMissingImports<CR>",
								{ buffer = buffer, desc = "Add Missing Imports" }
							)
							vim.keymap.set(
								"n",
								"<leader>cR",
								"<cmd>TypescriptRenameFile<CR>",
								{ desc = "Rename File", buffer = buffer }
							)
						end
					end)
					require("typescript").setup({ server = opts })
					return true
				end,
			},
		},
	},

	{
		"jose-elias-alvarez/null-ls.nvim",
		opts = function(_, opts)
			table.insert(opts.sources, require("typescript.extensions.null-ls.code-actions"))
		end,
	},
}
