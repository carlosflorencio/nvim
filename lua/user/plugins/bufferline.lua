return {
  {
    'akinsho/bufferline.nvim',
    enabled = true,
    event = 'VeryLazy',
    config = function()
      local bufferline = require 'bufferline'
      local colors = require('user.util.colors').colors

      require('bufferline').setup {
        options = {
          truncate_names = false,
          mode = 'tabs',
          sort_by = 'tabs',
          style_preset = bufferline.style_preset.no_italic,
          show_tab_indicators = false,
          always_show_bufferline = false,
          show_buffer_close_icons = false,
          show_close_icon = false,
          separator_style = 'thick',
          show_duplicate_prefix = false,
          tab_size = 5,
          indicator = {
            style = 'none',
          },
          diagnostics = 'nvim_lsp',
          offsets = {
            {
              filetype = 'NvimTree',
              text = '',
              -- same color as nvim-tree bg
              highlight = 'NvimTreeNormal',
              padding = 0,
              separator = true,
            },
          },
        },
        highlights = {
          -- vscode theme hightlights
          background = {
            fg = { attribute = 'fg', highlight = 'Normal' },
            bg = { attribute = 'bg', highlight = 'Normal' },
          },
          buffer_selected = {
            bg = colors.accent,
          },
          separator = {
            bg = { attribute = 'bg', highlight = 'Normal' },
          },
          error = {
            fg = colors.error,
          },
          modified = {
            bg = { attribute = 'bg', highlight = 'Normal' },
          },
          modified_selected = {
            bg = colors.accent,
          },
          error_selected = {
            bg = colors.accent,
          },
        },
      }
    end,
  },
}
