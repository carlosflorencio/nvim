return {
  {
    -- Automagically close the unedited buffers
    'axkirillov/hbac.nvim',
    -- when navigating in the quickfix list
    -- this plugin will close the buffers so navigating returns errors
    enabled = false,
    config = function()
      require('hbac').setup {
        threshold = 10,
      }
    end,
  },
}
