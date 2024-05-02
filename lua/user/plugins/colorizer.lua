return {
  {
    'NvChad/nvim-colorizer.lua',
    config = function()
      require('colorizer').setup {
        filetypes = {
          'css',
          'reacttypescript',
          'lua',
          html = { mode = 'foreground' },
        },
      }
    end,
  },
}
