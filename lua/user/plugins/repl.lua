return {
  {
    -- scratch files
    -- Codi! to stop
    -- .mathjs: npm install -g mathjs
    -- .ts: npm install -g tsun
    'metakirby5/codi.vim',
    -- enabled = false,
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
    -- .ts: npm install -g ts-node typescript
    'michaelb/sniprun',
    lazy = true,
    build = 'sh ./install.sh',
    cmd = { 'SnipRun', 'SnipLive' },
    opts = {
      display = { 'Classic' },
      -- display = { 'TempFloatingWindow' },
      -- display = { 'LongTempFloatingWindow' },
      -- display = { 'VirtualText' },
    },
  },
}
