---@type vim.lsp.Config
return {
  root_markers = { '.test' },
  root_dir = require('lspconfig').util.root_pattern('deno.json', 'deno.jsonc'),
}
