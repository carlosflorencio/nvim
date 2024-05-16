return {
  {
    -- floating notes
    'JellyApple102/flote.nvim',
    lazy = true,
    config = function()
      require('flote').setup {
        window_border = 'single',
        window_style = 'minimal',
        window_title = true,
        notes_dir = vim.g.personal_notes .. '/Projects',
        files = {
          global = 'global.md',
          cwd = function()
            local bufPath = vim.api.nvim_buf_get_name(0)
            local cwd = require('lspconfig').util.root_pattern '.git'(bufPath)

            vim.notify(cwd)
            return cwd
          end,
        },
      }
    end,
    keys = {
      { '<leader>pn', '<cmd>Flote<CR>', desc = 'Project Notes' },
    },
  },
}
