---@type vim.lsp.Config
return {
  settings = {
    eslint = {
      -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
      workingDirectory = { mode = 'auto' },
    },
  },
}
