return {
  {
    'L3MON4D3/LuaSnip',
    -- enabled = false,
    dependencies = {
      { 'rafamadriz/friendly-snippets' },
    },
    -- follow latest release.
    version = 'v2.*',
    build = 'make install_jsregexp',
    opts = {
      enable_autosnippets = true,
    },
    config = function(_, opts)
      local luasnip = require 'luasnip'
      luasnip.setup(opts)

      luasnip.filetype_extend('javascriptreact', { 'html' })
      luasnip.filetype_extend('typescriptreact', { 'html' })
      -- i don't want this, snippets appear duplicated
      -- luasnip.filetype_extend('javascript', { 'typescript' })

      require 'user.snippets.typescript'
      require 'user.snippets.lua'
      require('luasnip.loaders.from_vscode').lazy_load {} -- loads friendly snippets
      require('luasnip.loaders.from_vscode').lazy_load { paths = { './snippets' } }
    end,
  },
}
