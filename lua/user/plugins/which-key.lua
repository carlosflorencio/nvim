return {
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 550
    end,
    opts = {
      plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        spelling = true,
      },
    },
    config = function(_, opts)
      local wk = require 'which-key'
      wk.setup(opts)
      local keymaps = {
        mode = { 'n', 'v' },
        ['g'] = {
          name = '+goto',
        },
        [']'] = {
          name = '+next',
        },
        ['['] = {
          name = '+prev',
        },
        ['<leader>c'] = {
          name = '+close',
        },
        ['<leader>a'] = {
          name = '+AI',
        },
        ['<leader>l'] = {
          name = '+lsp',
        },
        ['<leader>f'] = {
          name = '+find',
        },
        ['<leader>g'] = {
          name = '+git',
        },
        ['<leader>q'] = {
          name = '+quit/session',
        },
        ['<leader>s'] = {
          name = '+split',
        },
        ['<leader>t'] = {
          name = '+toggle',
        },
        ['<leader>d'] = {
          name = '+debug',
        },
        ['<leader>o'] = {
          name = '+organize',
        },
        -- ['<leader>h'] = {
        -- },
        --   name = '+http',
        [',b'] = {
          name = '+breakpoints',
        },
        [',t'] = {
          name = '+test',
        },
        [',o'] = {
          name = '+other file',
        },
      }
      wk.register(keymaps)
    end,
  },
}
