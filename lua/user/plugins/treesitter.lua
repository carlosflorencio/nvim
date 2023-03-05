return {{
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = {"BufReadPost", "BufNewFile"},
    dependencies = {"nvim-treesitter/nvim-treesitter-textobjects", "RRethy/nvim-treesitter-textsubjects"},
    ---@type TSConfig
    opts = {
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = true
        },
        autotag = true,
        playground = {
            enable = true
        },
        indent = {
            enable = true
        },
        context_commentstring = {
            enable = true,
            enable_autocmd = false
        },
        ensure_installed = {"regex", "lua", "vim", "query", "c", "css", "go", "markdown", "php", "python", "ruby", "scss", "sql",
                            "svelte", "toml", "vue", "rust", "yaml", "jsdoc", "hcl", "cpp", "typescript", "javascript",
                            "tsx", "jsonc", "json", "http", "gitignore", "fish", "dockerfile", "bash", "help"},
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<CR>", -- maps in normal mode to init the node/scope selection
                scope_incremental = "<S-TAB>", -- increment to the upper scope (as defined in locals.scm)
                node_incremental = "<CR>", -- increment to the upper named parent
                node_decremental = "<TAB>" -- decrement to the previous node
            }
        },
        textsubjects = {
            enable = true
        },
        textobjects = {
            select = {
                enable = true,
                -- Automatically jump forward to textobj, similar to targets.vim
                lookahead = false,

                keymaps = {
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",

                    ["ac"] = "@conditional.outer",
                    ["ic"] = "@conditional.inner"

                    -- ["aa"] = "@parameter.outer",
                    -- ["ia"] = "@parameter.inner",

                },
                include_surrounding_whitespace = false
            },
            move = {
                enable = true,
                set_jumps = true, -- whether to set jumps in the jumplist
                goto_next_start = {
                    [']]'] = '@function.outer'
                    -- [']]'] = '@class.outer',
                },
                goto_next_end = {
                    [']M'] = '@function.outer'
                    -- [']['] = '@class.outer',
                },
                goto_previous_start = {
                    ['[['] = '@function.outer'
                    -- ['[['] = '@class.outer',
                },
                goto_previous_end = {
                    ['[M'] = '@function.outer'
                    -- ['[]'] = '@class.outer',
                }
            }
        }
    },
    ---@param opts TSConfig
    config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)
    end
}}
