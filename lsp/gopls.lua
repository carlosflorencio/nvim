---@type vim.lsp.Config
return {
  -- temporary fix for https://github.com/neovim/neovim/issues/28058
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = false,
      },
    }
  },
  root_markers = { 'go.work', 'go.mod', '.git' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
}
