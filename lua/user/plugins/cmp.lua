return { -- auto completion
	{
		"hrsh7th/nvim-cmp",
		version = false, -- last release is way too old
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lsp-signature-help",
		},
		---@param opts cmp.ConfigSchema
		opts = function(_, opts)
			local has_words_before = function()
				unpack = unpack or table.unpack
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			opts.mapping = vim.tbl_extend("force", opts.mapping or {}, {
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					-- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
					-- they way you will only jump inside the snippet region
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					elseif has_words_before() then
						cmp.complete()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			})

			opts.completion = {
				completeopt = "menu,menuone,noinsert",
			}

			opts.snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			}

			opts.sources = cmp.config.sources({
				{ name = "buffer" },
				{ name = "nvim_lsp_signature_help" },
				{
					name = "nvim_lsp",
					entry_filter = function(entry, ctx)
						local kind = require("cmp.types.lsp").CompletionItemKind[entry:get_kind()]
						if kind == "Snippet" and ctx.prev_context.filetype == "java" then
							return false
						end
						if kind == "Text" then
							return false
						end
						return true
					end,
					-- max_item_count = 5
				},
				{ name = "luasnip" },
				{ name = "path" },
				{ name = "nvim_lua" },
				{ name = "calc" },
				{ name = "emoji" },
				{ name = "treesitter" },
				{ name = "crates" },
				{ name = "tmux" },
			})

			opts.experimental = {
				ghost_text = {
					hl_group = "LspCodeLens",
				},
			}

			opts.cmdline = {
				enable = true,
				options = {
					{
						type = ":",
						sources = {
							{ name = "path" },
							{ name = "cmdline" },
						},
					},
					-- {
					--   type = { "/", "?" },
					--   sources = {
					--     { name = "buffer" },
					--   },
					-- },
				},
			}

			-- hide the copilot inline suggestion when the menu is open
			cmp.event:on("menu_opened", function()
				vim.b.copilot_suggestion_hidden = true
			end)

			cmp.event:on("menu_closed", function()
				vim.b.copilot_suggestion_hidden = false
			end)
		end,
	},

	-- snippets
	{
		"L3MON4D3/LuaSnip",
		build = (not jit.os:find("Windows"))
				and "echo -e 'NOTE: jsregexp is optional, so not a big deal if it fails to build\n'; make install_jsregexp"
			or nil,
		dependencies = {
			"rafamadriz/friendly-snippets",
			config = function()
				require("luasnip.loaders.from_vscode").lazy_load()
				require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./snippets" } })
			end,
		},
		opts = {
			history = true,
			delete_check_events = "TextChanged",
		},
		keys = function()
			return false
		end,
	},

	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
			panel = {
				enabled = true,
				auto_refresh = false,
				keymap = {
					jump_prev = "[[",
					jump_next = "]]",
					accept = "<M-l>",
					refresh = "gr",
					open = "<M-CR>",
				},
				layout = {
					position = "bottom", -- | top | left | right
					ratio = 0.4,
				},
			},
			suggestion = {
				enabled = true,
				auto_trigger = true,
				debounce = 75,
				keymap = {
					accept = "<M-l>",
					accept_word = false,
					accept_line = false,
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<M-h>",
				},
			},
			filetypes = {
				yaml = false,
				markdown = false,
				help = false,
				gitcommit = false,
				gitrebase = false,
				hgcommit = false,
				svn = false,
				cvs = false,
				["."] = false,
			},
			copilot_node_command = "node", -- Node.js version must be > 16.x
			server_opts_overrides = {},
		},
	},
}
