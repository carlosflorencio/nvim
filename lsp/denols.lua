---@type vim.lsp.Config
return {
  -- only enable on deno projects
  root_markers = { 'deno.json', 'deno.jsonc' },
}
