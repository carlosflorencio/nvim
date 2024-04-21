return {
  {
    -- open links with gx
    'chrishrb/gx.nvim',
    cmd = { 'Browse' },
    config = true, -- default settings
    keys = { { 'gx', '<cmd>Browse<cr>', mode = { 'n', 'x' } } },
  },
}
