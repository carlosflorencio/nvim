---@type vim.lsp.Config
return {
  root_markers = { '.test' },
  root_dir = vim.lsp.util.root_pattern('go.mod', '.git'),
}
