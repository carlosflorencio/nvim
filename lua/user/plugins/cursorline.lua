return {
  {
    -- cursorline only for the active window
    'tummetott/reticle.nvim',
    enabled = true,
    event = 'VeryLazy', -- lazyload the plugin if you like
    opts = {
      -- add options here if you want to overwrite defaults
      ignore = {
        cursorline = {
          'NvimTree',
        },
      },
    },
  },
}
