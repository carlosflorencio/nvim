return {
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        cmd = "Telescope",
        dependencies = {
            'nvim-lua/plenary.nvim',
            -- Fuzzy Finder Algorithm which requires local dependencies to be built.
            -- Only load if `make` is available. Make sure you have the system
            -- requirements installed.
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                -- NOTE: If you are having trouble with this installation,
                --       refer to the README for telescope-fzf-native for more instructions.
                build = 'make',
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
            },
            {
                "danielfalk/smart-open.nvim",
                branch = "0.2.x",
                dependencies = {
                    "kkharji/sqlite.lua",
                    {
                        "nvim-telescope/telescope-fzf-native.nvim",
                        build = "make",
                    },
                },
            },
        },
        config = function()
            local actions = require "telescope.actions"
            local telescope = require "telescope"

            telescope.setup {
                defaults = {
                },
                pickers = {
                    find_files = {
                        hidden = true,
                    },
                    live_grep = {
                        -- @usage don't include the filename in the search results
                        only_sort_text = true,
                    },
                    buffers = {
                        initial_mode = "normal",
                        theme = "dropdown",
                        mappings = {
                            i = {
                                ["<C-d>"] = actions.delete_buffer,
                            },
                            n = {
                                ["dd"] = actions.delete_buffer,
                            },
                        },
                    },
                    git_files = {
                        hidden = true,
                        show_untracked = true,
                    },
                    colorscheme = {
                        enable_preview = true,
                    },
                },
                extensions = {
                    smart_open = {
                        ignore_patterns = { "*.git/*", "*/tmp/*", "*/dist/*" },
                        match_algorithm = "fzf",
                    },
                },
            }

            telescope.load_extension "fzf"
            telescope.load_extension "smart_open"
        end,
        keys = {
            {
                "<leader>fb",
                "<cmd>Telescope git_branches initial_mode=normal<cr>",
                desc = "Checkout Branch",
            },
            {
                "<leader>j",
                "<cmd>Telescope buffers show_all_buffers=true previewer=false ignore_current_buffer=true sort_mru=true<cr>",
                desc = "Open Buffers",
            },
            { "<leader>tt", "<cmd>Telescope diagnostics initial_mode=normal<cr>", desc = "LSP Diagnostics" },
            {
                "<leader>fg",
                "<cmd>Telescope git_status initial_mode=normal  previewer=false sort_mru=true<cr>",
                desc = "Git changed files",
            },
            {
                "<leader>fa",
                "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<cr>",
                desc = "Find All Files",
            },
            {
                "<leader>ff",
                "<Cmd>lua require('telescope').extensions.smart_open.smart_open({cwd_only = true})<CR>",
                desc = "Find Project File",
            },
            {
                "<leader>fi",
                "<Cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
                desc = "Find workspace symbols",
            },
            { "<leader>fh", "<cmd>Telescope help_tags<cr>",                       desc = "Find Help" },
            { "<leader>fM", "<cmd>Telescope man_pages<cr>",                       desc = "Man Pages" },
            {
                "<leader>fr",
                "<cmd>Telescope oldfiles initial_mode=normal only_cwd=true<cr>",
                desc = "Open Recent Files",
            },
            { "<leader>fR", "<cmd>Telescope registers initial_mode=normal<cr>", desc = "Registers" },
            { "<leader>fw", "<cmd>Telescope live_grep_args<cr>",                desc = "Grep Text" },
            { "<leader>fk", "<cmd>Telescope keymaps<cr>",                       desc = "Keymaps" },
            { "<leader>fC", "<cmd>Telescope commands<cr>",                      desc = "Commands" },
            { "<leader>fu", "<cmd>Telescope undo initial_mode=normal<cr>",      desc = "Undo list" },
            {
                "<leader>ft",
                "<cmd>lua require('telescope.builtin').colorscheme({enable_preview = true})<cr>",
                desc = "Colorscheme with Preview",
            },
        }

    },

}
