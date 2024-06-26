return {
  {
    -- powerful search & replace
    'windwp/nvim-spectre',
    opts = {},
    keys = {
      {
        '<F3>',
        function()
          local path = vim.fn.fnameescape(vim.fn.expand '%:p:.')
          require('spectre').open_visual {
            select_word = true,
            path = path,
          }
        end,
        desc = 'Replace in files (Spectre)',
      },
      {
        '<leader>sr',
        function()
          local path = vim.fn.fnameescape(vim.fn.expand '%:p:.')
          require('spectre').open_visual {
            select_word = true,
            path = path,
          }
        end,
        desc = 'Replace in files (Spectre)',
      },
    },
  },
}
