return {
  {
    'bluz71/vim-moonfly-colors',
    name = 'moonfly',
    priority = 1000,
    init = function()
      vim.g.moonflyWinSeparator = 2 -- line instead of block
      vim.g.moonflyTransparent = true
      vim.g.moonflyNormalFloat = true
    end,
    config = function()
      vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
        group = vim.api.nvim_create_augroup('carlos/moonfly_theme', { clear = true }),
        pattern = '*',
        callback = function()
          -- bg color in Normal needed for Glance to calculate the background color
          vim.api.nvim_set_hl(0, 'Normal', { bg = '#000000' })
          vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE' })
          vim.api.nvim_set_hl(0, 'TabLine', { bg = 'NONE' })
          vim.api.nvim_set_hl(0, 'TabLineFill', { bg = 'NONE' })
          vim.api.nvim_set_hl(0, 'BufferLineFill', { bg = 'NONE' })
        end,
      })
    end,
  },
  {
    'wtfox/jellybeans.nvim',
    priority = 1000,
    opts = {},
  },
}
