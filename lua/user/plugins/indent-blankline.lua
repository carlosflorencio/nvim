return {
  {
    'lukas-reineke/indent-blankline.nvim',
    enabled = true,
    main = 'ibl',
    config = function()
      local char = '▏'

      require('ibl').setup {
        indent = {
          char = char,
        },
        scope = {
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
}
