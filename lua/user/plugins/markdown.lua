return {
  {
    -- preview markdown, glow needs to be installed globally
    'npxbr/glow.nvim',
    ft = { 'markdown' },
    opts = {
      width_ratio = 0.8, -- maximum width of the Glow window compared to the nvim window size (overrides `width`)
      height_ratio = 0.8,
    },
    keys = {
      { '<leader>pp', '<cmd>Glow<cr>', desc = 'Glow Markdown Preview' },
    },
  },
}
