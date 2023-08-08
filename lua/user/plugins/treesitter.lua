return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
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
        "nvim-treesitter/nvim-treesitter-textobjects",
        init = function()
          -- PERF: no need to load the plugin, if we only need its queries for mini.ai
          local plugin = require("lazy.core.config").spec.plugins["nvim-treesitter"]
          local opts = require("lazy.core.plugin").values(plugin, "opts", false)
          local enabled = false
          if opts.textobjects then
            for _, mod in ipairs { "move", "select", "swap", "lsp_interop" } do
              if opts.textobjects[mod] and opts.textobjects[mod].enable then
                enabled = true
                break
              end
            end
          end
          if not enabled then
            -- disable plugin treesitter config doesn't enable it
            require("lazy.core.loader").disable_rtp_plugin "nvim-treesitter-textobjects"
          end
        end,
      },
      -- better incremental selection
      "RRethy/nvim-treesitter-textsubjects",
      -- "nvim-treesitter/nvim-treesitter-context",
    },
    keys = {
      { "<cr>", desc = "Increment selection", mode = "x" },
      { "<bs>", desc = "Decrement selection", mode = "x" },
    },
    ---@type TSConfig
    opts = {
      -- Automatically install missing parsers when entering buffer
      auto_install = true,
      highlight = {
        enable = true,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
      },
      -- Indentation based on treesitter for the = operator.
      -- enabling it will cause bad indentation for some typescript code
      indent = {
        enable = false,
        -- disable = { "typescript", "html" },
      },

      -- nvim-ts-autotag
      autotag = {
        enable = true,
      },
      -- highlight and navigate on %
      matchup = {
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
        "typescript",
        "tsx",
        "jsonc",
        "json",
        "json5",
        "http",
        "gitignore",
        "fish",
        "dockerfile",
        "bash",
        "vimdoc",
      },
      incremental_selection = {
        enable = false,
      },
      -- better incremental selection
      textsubjects = {
        enable = true,
        prev_selection = "<bs>", -- (Optional) keymap to select the previous selection
        keymaps = {
          ["<cr>"] = "textsubjects-smart",
          [";"] = "textsubjects-container-outer",
          ["i;"] = "textsubjects-container-inner",
        },
      },
    },
    ---@param opts TSConfig
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
