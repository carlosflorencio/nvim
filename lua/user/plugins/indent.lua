return {
  {
    'lukas-reineke/indent-blankline.nvim',
    enabled = false,
    main = 'ibl',
    config = function()
      local char = '▏'

      require('ibl').setup {
        indent = {
          char = char,
        },
        scope = {
          enabled = true,
          show_start = false,
          show_end = false,
        },
      }
      local hooks = require 'ibl.hooks'

      hooks.register(hooks.type.VIRTUAL_TEXT, function(_, _, _, virt_text)
        if virt_text[1] and virt_text[1][1] == char then
          virt_text[1] = { ' ', { '@ibl.whitespace.char.1' } }
        end

        return virt_text
      end)
    end,
  },

  {
    'Mr-LLLLL/cool-chunk.nvim',
    enabled = false,
    event = { 'CursorHold', 'CursorHoldI' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('cool-chunk').setup {}
    end,
  },

  {
    'shellRaining/hlchunk.nvim',
    enabled = true,
    event = { 'UIEnter' },
    config = function()
      require('hlchunk').setup {
        indent = {
          enable = false,
        },
        blank = {
          enable = false,
        },
      }
    end,
  },
}
