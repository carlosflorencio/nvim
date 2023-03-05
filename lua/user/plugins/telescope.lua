local layout_config = {
    horizontal = {
        prompt_position = "bottom",
        preview_width = 0.55,
        results_width = 0.8
    },
    vertical = {
        mirror = false
    },
    width = 0.87,
    height = 0.87,
    preview_cutoff = 120
}

return {{
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = {{
        "danielfalk/smart-open.nvim",
        branch = "0.1.x",
        dependencies = {"kkharji/sqlite.lua"}
    }, 'nvim-lua/plenary.nvim', "telescope-fzf-native.nvim", "nvim-telescope/telescope-live-grep-args.nvim",
                    "nvim-telescope/telescope-dap.nvim"},
    cmd = "Telescope",
    opts = {
        defaults = {
            file_ignore_patterns = {".git", "node_modules"},
            path_display = {"truncate"},
            dynamic_preview_title = true
        },
        pickers = {
            find_files = {
                hidden = true,
                layout_config = layout_config,
                previewer = nil -- show previewer
            },
            live_grep = {
                -- @usage don't include the filename in the search results
                only_sort_text = true,
                layout_config = layout_config,
                previewer = nil -- show previewer
            }
        },
        extensions = {
            live_grep_args = {
                auto_quoting = true, -- enable/disable auto-quoting
                -- define mappings, e.g.
                mappings = { -- extend mappings
                    i = {
                        ["<C-k>"] = function(...)
                            require("telescope-live-grep-args.actions").quote_prompt()
                        end,
                        ["<C-i>"] = function()
                            require("telescope-live-grep-args.actions").quote_prompt({
                                postfix = " --iglob "
                            })
                        end
                    }
                }
            },
            smart_open = {
                ignore_patterns = {"*.git/*", "*/tmp/*", "*/dist/*"}
            }
        }
    },
    config = function(_, opts)
        local telescope = require("telescope")
        telescope.setup(opts)
        telescope.load_extension("fzf")
        telescope.load_extension("live_grep_args")
        telescope.load_extension("notify")
        telescope.load_extension("dap")
        telescope.load_extension("luasnip")
        telescope.load_extension("smart_open")
        telescope.load_extension("undo")
        telescope.load_extension("yank_history")
        telescope.load_extension("aerial")
        telescope.load_extension("refactoring")
    end,
    keys = {{
        "<leader>fb",
        "<cmd>Telescope git_branches initial_mode=normal<cr>",
        desc = "Checkout Branch"
    }, {"<leader>fd", "<cmd>Telescope diagnostics<cr>", "LSP Diagnostics"},
            {"<leader>fg", "<cmd>Telescope git_status<cr>", "Git changed files"},
            {"<leader>fc", "<cmd>Telescope command_history initial_mode=normal<cr>", "Command History"},
            {"<leader>fa", "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<cr>", "Find All Files"},
            {"<leader>ff", "<Cmd>lua require('telescope').extensions.smart_open.smart_open()<CR>", "Find Project File"},
            {"<leader>fi", "<Cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Find workspace symbols"},
            {"<leader>fh", "<cmd>Telescope help_tags<cr>", "Find Help"},
            {"<leader>fM", "<cmd>Telescope man_pages<cr>", "Man Pages"},
            {"<leader>fr", "<cmd>Telescope oldfiles initial_mode=normal only_cwd=true<cr>", "Open Recent Files"},
            {"<leader>fR", "<cmd>Telescope registers initial_mode=normal<cr>", "Registers"},
            {"<leader>fw", "<cmd>Telescope live_grep_args<cr>", "Grep Text"},
            {"<leader>fk", "<cmd>Telescope keymaps<cr>", "Keymaps"},
            {"<leader>fC", "<cmd>Telescope commands<cr>", "Commands"},
            {"<leader>fs", "<cmd>Telescope aerial<cr>", "Document Symbols by Aerial"},
            {"<leader>fp", "<cmd>Telescope projects<cr>", "Projects"},
            {"<leader>fS", "<cmd>Telescope luasnip theme=dropdown<cr>", "Snippets"},
            {"<leader>fu", "<cmd>Telescope undo<cr>", "Undo list"},
            {"<leader>ft", "<cmd>lua require('telescope.builtin').colorscheme({enable_preview = true})<cr>",
             "Colorscheme with Preview"}}
}, -- Fuzzy Finder Algorithm which requires local dependencies to be built.
-- Only load if `make` is available. Make sure you have the system
-- requirements installed.
{
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = function()
        return vim.fn.executable 'make' == 1
    end
}}
