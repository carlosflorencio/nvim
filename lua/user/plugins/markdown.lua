return {
  {
    'OXY2DEV/markview.nvim',
    enabled = true,
    event = 'VeryLazy',
    lazy = false, -- Recommended
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      local presets = require 'markview.presets'

      require('markview').setup {
        -- filetypes = { 'markdown', 'copilot-chat', 'codecompanion' },

        headings = presets.headings.glow,
        checkboxes = presets.checkboxes.nerd,
        horizontal_rules = presets.horizontal_rules.dotted,

        list_items = {
          enable = true,

          marker_minus = {
            add_padding = false,
          },
          marker_plus = {
            add_padding = false,
          },
          marker_star = {
            add_padding = false,
          },
          marker_dot = {
            add_padding = false,
          },
        },

        code_blocks = {
          style = 'minimal',
          icons = false,
        },

        -- insert mode rendering
        modes = { 'n', 'i', 'no', 'c' },
        hybrid_modes = { 'n' },

        -- This is nice to have
        -- callbacks = {
        --   on_enable = function(_, win)
        --     vim.wo[win].conceallevel = 2
        --     vim.wo[win].concealcursor = 'nc'
        --     vim.wo[win].signcolumn = 'no'
        --   end,
        -- },
      }
    end,
  },

  {
    'gaoDean/autolist.nvim',
    ft = {
      'markdown',
      'text',
      'tex',
      'plaintex',
      'norg',
    },
    -- making CR mapping work
    -- needs to load after those
    dependencies = {
      'hrsh7th/nvim-cmp',
      'windwp/nvim-autopairs',
    },
    config = function()
      require('autolist').setup()

      vim.keymap.set('i', '<tab>', '<cmd>AutolistTab<cr>')
      vim.keymap.set('i', '<s-tab>', '<cmd>AutolistShiftTab<cr>')
      vim.keymap.set('i', '<CR>', '<CR><cmd>AutolistNewBullet<cr>')
      vim.keymap.set('n', 'o', 'o<cmd>AutolistNewBullet<cr>')
      vim.keymap.set('n', 'O', 'O<cmd>AutolistNewBulletBefore<cr>')
      vim.keymap.set('n', '<C-r>', '<cmd>AutolistRecalculate<cr>')

      -- cycle list types with dot-repeat
      vim.keymap.set('n', '<leader>cn', require('autolist').cycle_next_dr, { expr = true })
      vim.keymap.set('n', '<leader>cp', require('autolist').cycle_prev_dr, { expr = true })

      -- functions to recalculate list on edit
      vim.keymap.set('n', '>>', '>><cmd>AutolistRecalculate<cr>')
      vim.keymap.set('n', '<<', '<<<cmd>AutolistRecalculate<cr>')
      vim.keymap.set('n', 'dd', 'dd<cmd>AutolistRecalculate<cr>')
      vim.keymap.set('v', 'd', 'd<cmd>AutolistRecalculate<cr>')
    end,
  },
}
