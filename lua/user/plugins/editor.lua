return {{
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        plugins = {
            spelling = true
        }
    },
    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)
        local keymaps = {
            mode = {"n", "v"},
            ["g"] = {
                name = "+goto"
            },
            ["gz"] = {
                name = "+surround"
            },
            ["]"] = {
                name = "+next"
            },
            ["["] = {
                name = "+prev"
            },
            ["<leader>c"] = {
                name = "+close"
            },
            ["<leader>l"] = {
                name = "+lsp"
            },
            ["<leader>f"] = {
                name = "+find/file"
            },
            ["<leader>g"] = {
                name = "+git"
            },
            ["<leader>gh"] = {
                name = "+hunks"
            },
            ["<leader>q"] = {
                name = "+quit/session"
            },
            ["<leader>s"] = {
                name = "+split"
            },
            ["<leader>t"] = {
                name = "+toggle"
            },
            ["<leader>d"] = {
                name = "+debug"
            },
            ["<leader>o"] = {
                name = "+organize/reviews"
            },
            ["<leader>h"] = {
                name = "+http"
            },
            [",t"] = {
                name = "+test"
            }
        }
        wk.register(keymaps)
    end
}, {
    -- improved marks
    "chentoast/marks.nvim",
    opts = {},
    lazy = false
}, {
    "wellle/targets.vim",
    lazy = false
}, {
    -- Image asci previewer
    'samodostal/image.nvim',
    dependencies = {'nvim-lua/plenary.nvim'},
    opts = {},
    lazy = false
}, {
    'rmagatti/auto-session',
    opts = {
        log_level = "error",
        auto_session_suppress_dirs = {"~/", "~/Projects", "~/Downloads", "/"},
        auto_session_use_git_branch = true
    },
    lazy = false
}, {
    -- buffers separated per tab
    "tiagovla/scope.nvim",
    opts = {},
    lazy = false
}, {
    -- inline run code
    'michaelb/sniprun',
    cmd = {"SnipRun"},
    build = 'bash ./install.sh'
}, {
    -- generate docblocks
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {
        snippet_engine = "luasnip"
    },
    keys = {{"<leader>hc", '<cmd>lua require("neogen").generate()<cr>', "Generate Comment Annotation"}}
}, {
    "asiryk/auto-hlsearch.nvim",
    event = "BufRead",
    opts = {}
}, {
    "folke/todo-comments.nvim",
    event = "BufRead",
    opts = {}
}, {
    -- auto close tags <div| => <div></div>
    "windwp/nvim-ts-autotag",
    opts = {},
    lazy = false
}, {
    "ggandor/leap.nvim",
    event = "BufRead",
    config = function()
        require("leap").set_default_keymaps()
    end
}, {
    -- powerful search & replace
    "windwp/nvim-spectre",
    opts = {},
    -- stylua: ignore
    keys = {{
        "<F3>",
        function()
            local path = vim.fn.fnameescape(vim.fn.expand('%:p:.'))
            require('spectre').open_visual({
                select_word = true,
                path = path
            })
        end,
        desc = "Replace in files (Spectre)"
    }}
}, {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
    keys = {{"<leader>tg", "<cmd>TroubleToggle<cr>", "Trouble"},
            {"<leader>tw", "<cmd>TroubleToggle workspace_diagnostics<cr>", "workspace"},
            {"<leader>td", "<cmd>TroubleToggle document_diagnostics<cr>", "document"},
            {"<leader>tq", "<cmd>TroubleToggle quickfix<cr>", "quickfix"},
            {"<leader>tl", "<cmd>TroubleToggle loclist<cr>", "loclist"},
            {"<leader>tr", "<cmd>TroubleToggle lsp_references<cr>", "references"}}
}, {
    -- surround with selection highlight
    "kylechui/nvim-surround",
    opts = {},
    lazy = false
}, {
    -- expand <C-a>/<C-x> toggles increments
    "nat-418/boole.nvim",
    opts = {
        mappings = {
            increment = '<C-a>',
            decrement = '<C-x>'
        }
    },
    lazy = false
}, {
    -- edit fs as a buffer
    "elihunter173/dirbuf.nvim",
    cmd = {"Dirbuf"}
}, -- add folding range to capabilities - nvim-ufo
{
    "neovim/nvim-lspconfig",
    opts = {
        capabilities = {
            textDocument = {
                foldingRange = {
                    dynamicRegistration = false,
                    lineFoldingOnly = true
                }
            }
        }
    }
}, {
    -- folds
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    event = "BufReadPost",
    opts = {
        close_fold_kinds = {'imports'},
        -- provider_selector = function(bufnr, filetype, buftype)
        --   return { 'treesitter', 'indent' }
        -- end,
        preview = {
            mappings = {
                scrollU = '<C-u>',
                scrollD = '<C-d>'
            }
        }
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
    end
}, {
    "andymass/vim-matchup",
    event = "BufReadPost",
    config = function()
        vim.g.matchup_matchparen_offscreen = {
            method = "status_manual"
        }
    end
},
  {
    -- detect correct tab width between files, e.g prettier 3 spaces
    'nmac427/guess-indent.nvim',
    opts = {},
    lazy = false
  },
{
  "echasnovski/mini.pairs",
  event = "VeryLazy",
  config = function(_, opts)
    require("mini.pairs").setup(opts)
  end,
}

}
