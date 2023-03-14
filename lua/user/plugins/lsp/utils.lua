local M = {}

function M.on_attach(client, bufnr)
  require("user.plugins.lsp.format").on_attach(client, bufnr)
  require("user.plugins.lsp.keymaps").on_attach(client, bufnr)

  if client.name == "tsserver" then
    -- https://github.com/jose-elias-alvarez/typescript.nvim
    vim.keymap.set(
      "n",
      "<leader>oi",
      "<cmd>TypescriptOrganizeImports<CR>",
      { buffer = bufnr, desc = "Organize Imports" }
    )
    vim.keymap.set(
      "n",
      "<leader>oa",
      "<cmd>TypescriptAddMissingImports<CR>",
      { buffer = bufnr, desc = "Add Missing Imports" }
    )
    vim.keymap.set("n", "<leader>cR", "<cmd>TypescriptRenameFile<CR>", { desc = "Rename File", buffer = bufnr })
  end
end

function M.capabilities()
  local cmp_lsp = require "cmp_nvim_lsp"

  local updated_capabilities = vim.lsp.protocol.make_client_capabilities()
  vim.tbl_deep_extend("force", updated_capabilities, cmp_lsp.default_capabilities())

  -- nvim-ufo
  updated_capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  return updated_capabilities
end

return M
