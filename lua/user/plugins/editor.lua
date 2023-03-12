return {

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			plugins = {
				spelling = true,
			},
		},
		config = function(_, opts)
			local wk = require("which-key")
			wk.setup(opts)
			local keymaps = {
				mode = { "n", "v" },
				["g"] = {
					name = "+goto",
				},
				["]"] = {
					name = "+next",
				},
				["["] = {
					name = "+prev",
				},
				["<leader>c"] = {
					name = "+close",
				},
				["<leader>l"] = {
					name = "+lsp",
				},
				["<leader>b"] = {
					name = "+breakpoints",
				},
				["<leader>f"] = {
					name = "+find/file",
				},
				["<leader>g"] = {
					name = "+git",
				},
				["<leader>gh"] = {
					name = "+hunks",
				},
				["<leader>q"] = {
					name = "+quit/session",
				},
				["<leader>s"] = {
					name = "+split",
				},
				["<leader>t"] = {
					name = "+toggle",
				},
				["<leader>d"] = {
					name = "+debug",
				},
				["<leader>o"] = {
					name = "+organize/reviews",
				},
				["<leader>h"] = {
					name = "+http",
				},
				[",t"] = {
					name = "+test",
				},
			}
			wk.register(keymaps)
		end,
	},

	{
		-- improved marks
		"chentoast/marks.nvim",
		opts = {},
		lazy = false,
	},

	{
		-- Image asci previewer
		"samodostal/image.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
		lazy = false,
	},

	{
		"rmagatti/auto-session",
		opts = {
			log_level = "error",
			auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
			auto_session_use_git_branch = true,
		},
		lazy = false,
	},
	{
		-- buffers separated per tab
		"tiagovla/scope.nvim",
		opts = {},
		lazy = false,
	},

	{
		-- inline run code
		"michaelb/sniprun",
		cmd = { "SnipRun" },
		build = "bash ./install.sh",
	},

	{
		-- generate docblocks
		"danymat/neogen",
		dependencies = "nvim-treesitter/nvim-treesitter",
		opts = {
			snippet_engine = "luasnip",
		},
		keys = { { "<leader>hc", '<cmd>lua require("neogen").generate()<cr>', "Generate Comment Annotation" } },
	},

	{
		"asiryk/auto-hlsearch.nvim",
		event = "BufRead",
		opts = {},
	},

	{
		"folke/todo-comments.nvim",
		event = "BufRead",
		opts = {},
	},
	{
		-- auto close tags <div| => <div></div>
		"windwp/nvim-ts-autotag",
		opts = {},
		lazy = false,
	},

	{
		"ggandor/leap.nvim",
		event = "BufRead",
		config = function()
			require("leap").set_default_keymaps()
		end,
	},

	{
		-- powerful search & replace
		"windwp/nvim-spectre",
		opts = {},
        -- stylua: ignore
        keys = {
            {
                "<F3>",
                function()
                    local path = vim.fn.fnameescape(vim.fn.expand('%:p:.'))
                    require('spectre').open_visual({
                        select_word = true,
                        path = path
                    })
                end,
                desc = "Replace in files (Spectre)"
            }
        }
,
	},
	{
		"folke/trouble.nvim",
		cmd = "TroubleToggle",
		keys = {
			{ "<leader>tg", "<cmd>TroubleToggle<cr>", "Trouble" },
			{ "<leader>tw", "<cmd>TroubleToggle workspace_diagnostics<cr>", "workspace" },
			{ "<leader>td", "<cmd>TroubleToggle document_diagnostics<cr>", "document" },
			{ "<leader>tq", "<cmd>TroubleToggle quickfix<cr>", "quickfix" },
			{ "<leader>tl", "<cmd>TroubleToggle loclist<cr>", "loclist" },
			{ "<leader>tr", "<cmd>TroubleToggle lsp_references<cr>", "references" },
		},
	},
	{
		-- surround with selection highlight
		"kylechui/nvim-surround",
		opts = {},
		lazy = false,
	},
	{
		-- expand <C-a>/<C-x> toggles increments
		"nat-418/boole.nvim",
		opts = {
			mappings = {
				increment = "<C-a>",
				decrement = "<C-x>",
			},
		},
		lazy = false,
	},
	{
		-- edit fs as a buffer
		"elihunter173/dirbuf.nvim",
		cmd = { "Dirbuf" },
		keys = {
			{ "<leader>'", "<cmd>Dirbuf<cr>", "Dirbuf" },
		},
	},

	-- add folding range to capabilities - nvim-ufo
	{
		"neovim/nvim-lspconfig",
		opts = {
			capabilities = {
				textDocument = {
					foldingRange = {
						dynamicRegistration = false,
						lineFoldingOnly = true,
					},
				},
			},
		},
	},

	{
		-- folds
		"kevinhwang91/nvim-ufo",
		dependencies = "kevinhwang91/promise-async",
		event = "BufReadPost",
		opts = {
			close_fold_kinds = { "imports" },
			-- provider_selector = function(bufnr, filetype, buftype)
			--   return { 'treesitter', 'indent' }
			-- end,
			preview = {
				mappings = {
					scrollU = "<C-u>",
					scrollD = "<C-d>",
				},
			},
		},
		init = function()
			-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
			vim.keymap.set("n", "zR", function()
				require("ufo").openAllFolds()
			end)
			vim.keymap.set("n", "zM", function()
				require("ufo").closeAllFolds()
			end)

			vim.keymap.set("n", "zr", function()
				require("ufo").openFoldsExceptKinds()
			end)

			vim.keymap.set("n", "zm", function()
				require("ufo").closeFoldsWith()
			end)
		end,
	},
	{
		"andymass/vim-matchup",
		event = "BufReadPost",
		config = function()
			vim.g.matchup_matchparen_offscreen = {
				method = "status_manual",
			}
		end,
	},
	{
		-- detect correct tab width between files, e.g prettier 3 spaces
		"nmac427/guess-indent.nvim",
		opts = {},
		lazy = false,
	},
	{
		"echasnovski/mini.pairs",
		event = "VeryLazy",
		config = function(_, opts)
			require("mini.pairs").setup(opts)
		end,
	},

	-- comments
	{ "JoosepAlviste/nvim-ts-context-commentstring" },
	{
		"numToStr/Comment.nvim",
		opts = {
			ignore = "^$",
			pre_hook = function(...)
				local loaded, ts_comment = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
				if loaded and ts_comment then
					return ts_comment.create_pre_hook()(...)
				end
			end,
		},
		keys = {
			{ "gc", mode = { "n", "v" } },
			{ "gb", mode = { "n", "v" } },
			{ "<leader>/", "<Plug>(comment_toggle_linewise_visual)", "Comment toggle linewise (visual)", mode = "v" },
			{ "<leader>/", "<Plug>(comment_toggle_linewise_current)", "Comment toggle current line" },
		},
		event = "User FileOpened",
	},

	-- better text-objects
	{
		"echasnovski/mini.ai",
		-- keys = {
		--   { "a", mode = { "x", "o" } },
		--   { "i", mode = { "x", "o" } },
		-- },
		event = "VeryLazy",
		dependencies = { "nvim-treesitter-textobjects" },
		opts = function()
			local ai = require("mini.ai")
			return {
				n_lines = 500,
				custom_textobjects = {
					o = ai.gen_spec.treesitter({
						a = { "@block.outer", "@conditional.outer", "@loop.outer" },
						i = { "@block.inner", "@conditional.inner", "@loop.inner" },
					}, {}),
					f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
					c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
				},
			}
		end,
		config = function(_, opts)
			require("mini.ai").setup(opts)
			-- register all text objects with which-key
			if require("user.util").has("which-key.nvim") then
				---@type table<string, string|table>
				local i = {
					[" "] = "Whitespace",
					['"'] = 'Balanced "',
					["'"] = "Balanced '",
					["`"] = "Balanced `",
					["("] = "Balanced (",
					[")"] = "Balanced ) including white-space",
					[">"] = "Balanced > including white-space",
					["<lt>"] = "Balanced <",
					["]"] = "Balanced ] including white-space",
					["["] = "Balanced [",
					["}"] = "Balanced } including white-space",
					["{"] = "Balanced {",
					["?"] = "User Prompt",
					_ = "Underscore",
					a = "Argument",
					b = "Balanced ), ], }",
					c = "Class",
					f = "Function",
					o = "Block, conditional, loop",
					q = "Quote `, \", '",
					t = "Tag",
				}
				local a = vim.deepcopy(i)
				for k, v in pairs(a) do
					a[k] = v:gsub(" including.*", "")
				end

				local ic = vim.deepcopy(i)
				local ac = vim.deepcopy(a)
				for key, name in pairs({ n = "Next", l = "Last" }) do
					i[key] = vim.tbl_extend("force", { name = "Inside " .. name .. " textobject" }, ic)
					a[key] = vim.tbl_extend("force", { name = "Around " .. name .. " textobject" }, ac)
				end
				require("which-key").register({
					mode = { "o", "x" },
					i = i,
					a = a,
				})
			end
		end,
	},

	{
		-- insert mode navigation on tab
		"abecodes/tabout.nvim",
		event = "InsertEnter",
		dependencies = "nvim-treesitter/nvim-treesitter",
		opts = {},
	},

	{
		"Wansmer/treesj",
		opts = { use_default_keymaps = false },
		keys = {
			{ "<leader>hs", "<cmd>TSJToggle<cr>", desc = "Join Toggle" },
		},
	},

	{
		"ckolkey/ts-node-action",
		dependencies = { "nvim-treesitter" },
		opts = {},
		keys = {
			{ "<leader>ha", '<cmd>lua require("ts-node-action").node_action()<cr>', "Toggle node action under cursor" },
		},
	},

	-- references
	{
		"RRethy/vim-illuminate",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			delay = 200,
			filetypes_denylist = {
				"dirvish",
				"fugitive",
				"alpha",
				"NvimTree",
				"lazy",
				"neogitstatus",
				"Trouble",
				"lir",
				"Outline",
				"spectre_panel",
				"toggleterm",
				"DressingSelect",
				"TelescopePrompt",
			},
		},
		config = function(_, opts)
			require("illuminate").configure(opts)

			local function map(key, dir, buffer)
				vim.keymap.set("n", key, function()
					require("illuminate")["goto_" .. dir .. "_reference"](false)
				end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
			end

			map("]]", "next")
			map("[[", "prev")

			-- also set it after loading ftplugins, since a lot overwrite [[ and ]]
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					local buffer = vim.api.nvim_get_current_buf()
					map("]]", "next", buffer)
					map("[[", "prev", buffer)
				end,
			})
		end,
		keys = {
			{ "]]", desc = "Next Reference" },
			{ "[[", desc = "Prev Reference" },
		},
	},

	{
		-- yank ring
		"gbprod/yanky.nvim",
		opts = {
			ring = {
				history_length = 50,
				storage = "shada",
				sync_with_numbered_registers = true,
				cancel_event = "update",
			},
			system_clipboard = {
				sync_with_ring = true,
			},
		},
		keys = {
			{ "p", "<Plug>(YankyPutAfter)", desc = "Yanky put after", mode = { "n", "x" } },
			{ "P", "<Plug>(YankyPutBefore)", desc = "Yanky put before", mode = { "n", "x" } },
			{ "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" } },
			{ "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" } },
			{ "<c-n>", "<Plug>(YankyCycleForward)", mode = "n" },
			{ "<c-p>", "<Plug>(YankyCycleBackward)", mode = "n" },
			{ "<c-v>", "<esc><cmd>Telescope yank_history initial_mode=normal<cr>", mode = { "n", "i" } },
			{ "y", "<Plug>(YankyYank)", mode = { "n", "x" } }, -- prevent going up when yanking
		},
	},

	{
		-- smart lists on text files, needs to be at the end to avoid plugin clashes
		"gaoDean/autolist.nvim",
		ft = {
			"markdown",
			"text",
			"tex",
			"plaintex",
		},
		config = function()
			local autolist = require("autolist")

			-- currently tab & cr are clashing with cmp
			autolist.setup()
			autolist.create_mapping_hook("i", "<CR>", autolist.new)
			autolist.create_mapping_hook("i", "<Tab>", autolist.indent)
			autolist.create_mapping_hook("i", "<S-Tab>", autolist.indent, "<C-D>")
			autolist.create_mapping_hook("i", "<C-t>", autolist.indent)
			autolist.create_mapping_hook("i", "<C-d>", autolist.indent)
			autolist.create_mapping_hook("n", "<C-t>", autolist.indent)
			autolist.create_mapping_hook("n", ">>", autolist.indent)
			autolist.create_mapping_hook("n", "<<", autolist.indent)

			autolist.create_mapping_hook("n", "o", autolist.new)
			autolist.create_mapping_hook("n", "O", autolist.new_before)

			autolist.create_mapping_hook("n", "<C-r>", autolist.force_recalculate)
			autolist.create_mapping_hook("n", "<leader>x", autolist.invert_entry, "")

			vim.api.nvim_create_autocmd("TextChanged", {
				pattern = "*",
				callback = function()
					vim.cmd.normal({ autolist.force_recalculate(nil, nil), bang = false })
				end,
			})
		end,
	},
}
