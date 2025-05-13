return {
  -- root_markers = { 'deno.json', 'deno.jsonc' },
  -- only enable on deno projects
  root_dir = require('lspconfig').util.root_pattern('deno.json', 'deno.jsonc'),
}
