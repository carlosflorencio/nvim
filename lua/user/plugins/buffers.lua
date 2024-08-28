return {
  {
    -- Automagically close the unedited buffers
    'axkirillov/hbac.nvim',
    enable = false,
    -- when navigating in the quickfix list
    -- this plugin will close the buffers so navigating returns errors
    enabled = true,
    config = function()
      require('hbac').setup {
        threshold = 20,
      }
    end,
  },
}
