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
      -- vim.api.nvim_set_hl(0, 'NvimTreeWinSeparator', { link = 'Ignore' })
      vim.api.nvim_set_hl(0, 'NvimTreeNormal', { bg = 'NONE' })
      vim.api.nvim_set_hl(0, 'NvimTreeEndOfBuffer', { bg = 'NONE' })
    end,
  },
}
