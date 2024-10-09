return {
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    build = ':TSUpdate',
    event = { 'VeryLazy' },
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treesitter** module to be loaded in time.
      -- Luckily, the only things that those plugins need are the custom queries, which we make available
      -- during startup.
      require('lazy.core.loader').add_to_rtp(plugin)
      require 'nvim-treesitter.query_predicates'
    end,
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-context',
        opts = {
          max_lines = 4,
        },
      },
    },
    opts = {
      ensure_installed = {
        'vimdoc',
        'javascript',
        'typescript',
        'tsx',
        'vim',
        'query',
        'go',
        'lua',
        'rust',
        'lua',
        'json',
        'css',
        'html',
        'yaml',
        'toml',
        'bash',
        'c',
        'comment',
        'csv',
        'diff',
        'dockerfile',
        'earthfile',
        'gitcommit',
        'git_rebase',
        'git_config',
        'gitattributes',
        'gitignore',
        'http',
        'java',
        'jsdoc',
        'kotlin',
        'luadoc',
        'php',
        'python',
        'ruby',
        'sql',
        'terraform',
        'xml',
        'markdown',
        'markdown_inline',
      },
      sync_install = false,
      auto_install = true,
      ignore_install = {},
      -- modules = {},
      highlight = {
        enable = true,
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
        disable = {
          -- better experience with native indentation
          'markdown',
        },
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<cr>',
          node_incremental = '<cr>',
          node_decremental = '<s-cr>',
        },
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    init = function()
      -- disable rtp plugin, as we only need its queries for mini.ai
      -- In case other textobject modules are enabled, we will load them
      -- once nvim-treesitter is loaded
      require('lazy.core.loader').disable_rtp_plugin 'nvim-treesitter-textobjects'
    end,
  },

  {
    'ckolkey/ts-node-action',
    dependencies = { 'nvim-treesitter' },
    enabled = true,
    config = function()
      local ts_node_action = require 'ts-node-action'
      ts_node_action.setup {
        tsx = ts_node_action.node_actions.typescriptreact,
      }
    end,
    keys = {
      {
        '<leader>sS',
        '<cmd>lua require("ts-node-action").node_action()<cr>',
        desc = 'Toggle node action under cursor',
      },
    },
  },

  {
    'Wansmer/treesj',
    opts = { use_default_keymaps = false },
    keys = {
      { '<leader>ss', '<cmd>TSJToggle<cr>', desc = 'Join Toggle' },
    },
  },

  {
    -- auto close tags <div| => <div></div>
    'windwp/nvim-ts-autotag',
    opts = {},
  },

  {
    -- convert "${}" to `${}`
    'axelvc/template-string.nvim',
    ft = {
      'html',
      'typescript',
      'javascript',
      'typescriptreact',
      'javascriptreact',
      'vue',
      'svelte',
      'python',
    }, -- filetypes where the plugin is active
    opts = {},
  },

  {
    -- incremental selection <cr>, <bs>
    'sustech-data/wildfire.nvim',
    enabled = false,
    event = 'VeryLazy',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('wildfire').setup()
    end,
  },
}
