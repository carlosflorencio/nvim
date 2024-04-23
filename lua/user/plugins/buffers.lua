return {
  {
    -- Automagically close the unedited buffers
    'axkirillov/hbac.nvim',
    config = function()
      require('hbac').setup {
        threshold = 10,
      }
    end,
  },
}
