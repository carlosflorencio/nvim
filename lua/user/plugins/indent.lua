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
      local ft = require 'hlchunk.utils.filetype'
      local exclude_filetypes = vim.tbl_extend('force', ft.exclude_filetypes, {
        Glance = true,
        oil = true,
        terminal = true,
        toml = true,
        yaml = true,
        fzf = true,
        lazygit = true,
      })

      ---@diagnostic disable-next-line: missing-fields
      require('hlchunk').setup {
        ---@diagnostic disable-next-line: missing-fields
        chunk = {
          exclude_filetypes = exclude_filetypes,
        },
        ---@diagnostic disable-next-line: missing-fields
        indent = {
          enable = false,
        },
        ---@diagnostic disable-next-line: missing-fields
        blank = {
          enable = false,
        },
      }
    end,
  },
}
