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
		config = function()
			local cmp = require("cmp")
			local status_cmp_ok, cmp_types = pcall(require, "cmp.types.cmp")
			if not status_cmp_ok then
				return
			end
			local ConfirmBehavior = cmp_types.ConfirmBehavior
			local SelectBehavior = cmp_types.SelectBehavior
			local cmp_utils = require("user.plugins.cmp.utils")
			local cmp_mapping = require("cmp.config.mapping")
			local cmp_window = require("cmp.config.window")

			local luasnip = require("luasnip")
			local icons = require("user.ui").icons

			local confirm_opts_default = {
				behavior = ConfirmBehavior.Replace,
				select = false,
			}

			local source_names = {
				nvim_lsp = "(LSP)",
				emoji = "(Emoji)",
				path = "(Path)",
				calc = "(Calc)",
				cmp_tabnine = "(Tabnine)",
				vsnip = "(Snippet)",
				luasnip = "(Snippet)",
				buffer = "(Buffer)",
				tmux = "(TMUX)",
				copilot = "(Copilot)",
				treesitter = "(TreeSitter)",
			}

			local duplicates = {
				buffer = 1,
				path = 1,
				nvim_lsp = 0,
				luasnip = 1,
			}

			local border_opts = {
				winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
			}

			cmp.setup({
				mapping = cmp.mapping.preset.insert({
					-- copilot
					["<C-l>"] = function()
						require("copilot.suggestion").accept()
					end,
					["<M-j>"] = function()
						require("copilot.suggestion").next()
					end,
					["<M-k>"] = function()
						require("copilot.suggestion").prev()
					end,

					["<C-k>"] = cmp_mapping(cmp_mapping.select_prev_item(), { "i", "c" }),
					["<C-j>"] = cmp_mapping(cmp_mapping.select_next_item(), { "i", "c" }),
					["<Down>"] = cmp_mapping(
						cmp_mapping.select_next_item({ behavior = SelectBehavior.Select }),
						{ "i" }
					),
					["<Up>"] = cmp_mapping(cmp_mapping.select_prev_item({ behavior = SelectBehavior.Select }), { "i" }),
					["<C-d>"] = cmp_mapping.scroll_docs(-4),
					["<C-f>"] = cmp_mapping.scroll_docs(4),
					["<C-y>"] = cmp_mapping({
						i = cmp_mapping.confirm({ behavior = ConfirmBehavior.Replace, select = false }),
						c = function(fallback)
							if cmp.visible() then
								cmp.confirm({ behavior = ConfirmBehavior.Replace, select = false })
							else
								fallback()
							end
						end,
					}),
					["<Tab>"] = cmp_mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						elseif cmp_utils.jumpable(1) then
							luasnip.jump(1)
						elseif cmp_utils.has_words_before() then
							-- cmp.complete()
							fallback()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp_mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
					["<C-Space>"] = cmp_mapping.complete(),
					["<C-e>"] = cmp_mapping.abort(),
					["<CR>"] = cmp_mapping(function(fallback)
						if cmp.visible() then
							local confirm_opts = vim.deepcopy(confirm_opts_default) -- avoid mutating the original opts below
							local is_insert_mode = function()
								return vim.api.nvim_get_mode().mode:sub(1, 1) == "i"
							end
							if is_insert_mode() then -- prevent overwriting brackets
								confirm_opts.behavior = ConfirmBehavior.Insert
							end
							if cmp.confirm(confirm_opts) then
								return -- success, exit early
							end
						end
						fallback() -- if not exited early, always fallback
					end),
				}),

				sources = cmp.config.sources({
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
				}),

				formatting = {
					fields = { "kind", "abbr", "menu" },
					duplicates_default = 0,
					format = function(entry, vim_item)
						local max_width = 0
						if max_width ~= 0 and #vim_item.abbr > max_width then
							vim_item.abbr = string.sub(vim_item.abbr, 1, max_width - 1) .. icons.ui.Ellipsis
						end
						vim_item.kind = icons.kinds[vim_item.kind]

						if entry.source.name == "copilot" then
							vim_item.kind = icons.git.Octoface
							vim_item.kind_hl_group = "CmpItemKindCopilot"
						end

						if entry.source.name == "cmp_tabnine" then
							vim_item.kind = icons.misc.Robot
							vim_item.kind_hl_group = "CmpItemKindTabnine"
						end

						if entry.source.name == "crates" then
							vim_item.kind = icons.misc.Package
							vim_item.kind_hl_group = "CmpItemKindCrate"
						end

						if entry.source.name == "lab.quick_data" then
							vim_item.kind = icons.misc.CircuitBoard
							vim_item.kind_hl_group = "CmpItemKindConstant"
						end

						if entry.source.name == "emoji" then
							vim_item.kind = icons.misc.Smiley
							vim_item.kind_hl_group = "CmpItemKindEmoji"
						end
						vim_item.menu = source_names[entry.source.name]
						vim_item.dup = duplicates[entry.source.name] or 0
						return vim_item
					end,
				},

				completion = {
					completeopt = "menu,menuone,noinsert",
				},

				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},

				experimental = {
					ghost_text = {
						hl_group = "LspCodeLens",
					},
				},

				window = {
					completion = cmp_window.bordered(border_opts),
					documentation = cmp_window.bordered(border_opts),
				},
			})

			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})

			-- hide the copilot inline suggestion when the menu is open
			-- cmp.event:on("menu_opened", function()
			-- 	vim.b.copilot_suggestion_hidden = true
			-- end)

			-- cmp.event:on("menu_closed", function()
			-- 	vim.b.copilot_suggestion_hidden = false
			-- end)
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
