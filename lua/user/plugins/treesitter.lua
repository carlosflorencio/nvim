return {
	{
		"nvim-treesitter/nvim-treesitter",
		version = false, -- last release is way too old and doesn't work on Windows
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter-textobjects",
				init = function()
					-- PERF: no need to load the plugin, if we only need its queries for mini.ai
					local plugin = require("lazy.core.config").spec.plugins["nvim-treesitter"]
					local opts = require("lazy.core.plugin").values(plugin, "opts", false)
					local enabled = false
					if opts.textobjects then
						for _, mod in ipairs({ "move", "select", "swap", "lsp_interop" }) do
							if opts.textobjects[mod] and opts.textobjects[mod].enable then
								enabled = true
								break
							end
						end
					end
					if not enabled then
						require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
					end
				end,
			},
			"RRethy/nvim-treesitter-textsubjects",
			"nvim-treesitter/nvim-treesitter-context",
			"nvim-treesitter/playground",
		},
		keys = {
			{ "<c-cr>", desc = "Increment selection" },
			{ "<bs>", desc = "Decrement selection", mode = "x" },
		},
		---@type TSConfig
		opts = {
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = true,
			},
			-- nvim-ts-autotag
			autotag = {
				enable = true,
			},
			playground = {
				enable = true,
			},
			-- highlight and navigate on %
			matchup = {
				enable = true,
			},
			indent = {
				enable = true,
			},
			-- with mini.comment
			context_commentstring = {
				enable = true,
				enable_autocmd = false,
			},
			ensure_installed = {
				"regex",
				"lua",
				"vim",
				"query",
				"c",
				"css",
				"go",
				"markdown",
				"php",
				"python",
				"ruby",
				"scss",
				"sql",
				"svelte",
				"toml",
				"vue",
				"rust",
				"yaml",
				"jsdoc",
				"hcl",
				"cpp",
				"javascript",
				"jsonc",
				"json",
				"http",
				"gitignore",
				"fish",
				"dockerfile",
				"bash",
				"help",
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<c-cr>", -- maps in normal mode to init the node/scope selection
					scope_incremental = "<c-cr>", -- increment to the upper scope (as defined in locals.scm)
					node_incremental = "<nop>", -- increment to the upper named parent
					node_decremental = "<bs>", -- decrement to the previous node
				},
			},
			textsubjects = {
				enable = true,
			},
		},
		---@param opts TSConfig
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
}
