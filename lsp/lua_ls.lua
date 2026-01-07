---@type vim.lsp.Config
return {
  -- cmd = {...},
  -- filetypes = { ...},
  -- capabilities = {},
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'hs' },
      },
      completion = {
        callSnippet = 'Replace',
      },
      workspace = {
        library = {
          ['/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/'] = true,
          [vim.fn.expand '~/.hammerspoon/Spoons/EmmyLua.spoon/annotations'] = true,
        },
      },
      -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      -- diagnostics = { disable = { 'missing-fields' } },
    },
  },
}
