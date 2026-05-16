---@type vim.lsp.Config
return {
  -- cmd = {...},
  -- filetypes = { ...},
  -- capabilities = {},
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim', 'hs' },
      },
      completion = {
        callSnippet = 'Replace',
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          '/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/',
          vim.fn.expand '~/.hammerspoon/Spoons/EmmyLua.spoon/annotations',
        },
      },
      -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      -- diagnostics = { disable = { 'missing-fields' } },
    },
  },
}
