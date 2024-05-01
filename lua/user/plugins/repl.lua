return {
  {
    -- scratch files
    -- Codi! to stop
    'metakirby5/codi.vim',
    lazy = true,
    cmd = { 'Codi', 'CodiNew', 'CodiSelect', 'CodiExpand' },
    init = function()
      vim.g['codi#rightalign'] = 0
      vim.g['codi#autoclose'] = 0
      vim.g['codi#virtual_text'] = 0
    end,
  },

  {
    -- Select a code block and :SnipRun
    'michaelb/sniprun',
    lazy = true,
    build = 'sh ./install.sh',
    cmd = { 'SnipRun' },
    opts = {
      -- display = { "Terminal" },
    },
  },
}
