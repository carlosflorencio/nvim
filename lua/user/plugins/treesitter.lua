return {
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = 'all',
      sync_install = false,
      auto_install = true,
      ignore_install = {},
      modules = {},
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
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
    config = function()
      local ts_node_action = require 'ts-node-action'
      ts_node_action.setup {
        tsx = ts_node_action.node_actions.typescriptreact,
      }
    end,
    keys = {
      {
        '<leader>ss',
        '<cmd>lua require("ts-node-action").node_action()<cr>',
        desc = 'Toggle node action under cursor',
      },
    },
  },
}
