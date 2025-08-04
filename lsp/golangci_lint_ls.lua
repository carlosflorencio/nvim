---@type vim.lsp.Config
return {
  -- root_markers = { '.test' },
  root_dir = require('lspconfig').util.root_pattern('go.mod'),
}
