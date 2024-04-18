return {
  {
    'navarasu/onedark.nvim',
    enabled = true,
    lazy = false,
    priority = 1000,
    config = function()
      require('onedark').setup {
        style = 'darker',
        ending_tildes = true,
        code_style = {
          comments = 'none',
        },
      }
      require('onedark').load()
    end,
  },

}
