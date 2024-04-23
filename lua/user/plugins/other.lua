return {
  {
    'rgroli/other.nvim',
    cmd = { 'Other', 'OtherVSplit', 'OtherSplit' },
    config = function()
      require('other-nvim').setup {
        mappings = {
          -- builtin mappings
          'golang',
          'c',
          -- jest
          {
            pattern = '/(.*)/(.+).ts$',
            target = '/%1/%2.spec.ts',
          },
          {
            pattern = '/(.*)/(.+).spec.ts$',
            target = '/%1/%2.ts',
          },
        },
        showMissingFiles = false,
        keybindings = {
          ['<cr>'] = 'open_file()',
          ['<esc>'] = 'close_window()',
          o = 'open_file()',
          q = 'close_window()',
          v = 'open_file_vs()',
          s = 'open_file_vs()',
          h = 'open_file_sp()',
          x = 'open_file_sp()',
        },
      }
    end,
    keys = {
      { ',oo', '<cmd>Other<cr>', desc = 'Open other file' },
      { ',ot', '<cmd>Other test<cr>', desc = 'Open other test file' },
      { ',ov', '<cmd>OtherVSplit<cr>', desc = 'Open other file vsplit' },
      { ',oh', '<cmd>OtherSplit<cr>', desc = 'Open other file split' },
    },
  },
}
