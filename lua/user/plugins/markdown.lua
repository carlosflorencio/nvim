return {
  {
    -- better vim docs
    'OXY2DEV/helpview.nvim',
    lazy = false, -- Recommended

    -- In case you still want to lazy load
    -- ft = "help",

    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
  },

  {
    'OXY2DEV/markview.nvim',
    enabled = true,
    event = 'VeryLazy',
    lazy = false, -- Recommended
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      local heading_presets = require('markview.presets').headings

      -- remove gutter icons
      heading_presets.decorated_labels.heading_1.sign = ''
      heading_presets.decorated_labels.heading_2.sign = ''
      heading_presets.decorated_labels.heading_3.sign = ''
      heading_presets.decorated_labels.heading_4.sign = ''
      heading_presets.decorated_labels.heading_5.sign = ''
      heading_presets.decorated_labels.heading_6.sign = ''
      -- print('here[1]: markdown.lua:80: heading_presets=' .. vim.inspect(heading_presets.decorated_labels))

      local hl_presets = require('markview.presets').highlight_groups
      require('markview').setup {
        filetypes = { 'markdown', 'copilot-chat' },
        -- headings
        highlight_groups = hl_presets.h_decorated,
        headings = heading_presets.decorated_labels,

        horizontal_rules = {
          parts = {
            {
              type = 'repeating',
              text = '─',

              direction = 'left',
              hl = {
                'Gradient1',
                'Gradient2',
                'Gradient3',
                'Gradient4',
                'Gradient5',
                'Gradient6',
                'Gradient7',
                'Gradient8',
                'Gradient9',
                'Gradient10',
              },

              repeat_amount = function()
                local w = vim.api.nvim_win_get_width(0)
                local l = vim.api.nvim_buf_line_count(0)

                l = vim.fn.strchars(tostring(l)) + 4

                return math.floor((w - (l + 3)) / 2)
              end,
            },
            {
              type = 'text',
              text = '  ',
            },
            {
              type = 'repeating',
              text = '─',

              direction = 'right',
              hl = {
                'Gradient1',
                'Gradient2',
                'Gradient3',
                'Gradient4',
                'Gradient5',
                'Gradient6',
                'Gradient7',
                'Gradient8',
                'Gradient9',
                'Gradient10',
              },

              repeat_amount = function()
                local w = vim.api.nvim_win_get_width(0)
                local l = vim.api.nvim_buf_line_count(0)

                l = vim.fn.strchars(tostring(l)) + 4

                return math.ceil((w - (l + 3)) / 2)
              end,
            },
          },
        },

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
          style = 'language',
          icons = false,
        },

        -- insert mode rendering
        modes = { 'n', 'i', 'no', 'c' },
        hybrid_modes = { 'i' },

        -- This is nice to have
        callbacks = {
          on_enable = function(_, win)
            vim.wo[win].conceallevel = 2
            vim.wo[win].conecalcursor = 'nc'
            vim.wo[win].signcolumn = 'no'
          end,
        },
      }
    end,
  },

  {
    -- Render markdown in normal mode
    'MeanderingProgrammer/render-markdown.nvim',
    enabled = false,
    ft = { 'markdown' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('render-markdown').setup {
        heading = {
          sign = false,
        },
        code = {},
      }
    end,
  },
}
