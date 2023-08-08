local M = {}

function M.on_attach(client, bufnr)
  require("user.plugins.lsp.format").on_attach(client, bufnr)
  require("user.plugins.lsp.keymaps").on_attach(client, bufnr)

  if client.name == "typescript-tools" then
    vim.keymap.set(
      "n",
      "<leader>oa",
      "<cmd>TSToolsAddMissingImports<CR>",
      { buffer = bufnr, desc = "Add Missing Imports" }
    )
    vim.keymap.set("n", "<leader>oi", "<cmd>TSToolsOrganizeImports<CR>", { buffer = bufnr, desc = "Organize Imports" })
    vim.keymap.set(
      "n",
      "<leader>ou",
      "<cmd>TSToolsRemoveUnusedImports<CR>",
      { buffer = bufnr, desc = "Remove Unused Imports/Variables" }
    )
  end

  if client.name == "tsserver" then
    -- https://github.com/jose-elias-alvarez/typescript.nvim cmds
    vim.keymap.set(
      "n",
      "<leader>oi",
      "<cmd>TypescriptOrganizeImports<CR>",
      { buffer = bufnr, desc = "Organize Imports" }
    )
    vim.keymap.set(
      "n",
      "<leader>ou",
      "<cmd>TypescriptRemoveUnused<CR>",
      { buffer = bufnr, desc = "Remove Unused Imports/Variables" }
    )
    vim.keymap.set(
      "n",
      "<leader>oa",
      "<cmd>TypescriptAddMissingImports<CR>",
      { buffer = bufnr, desc = "Add Missing Imports" }
    )
    vim.keymap.set("n", "<leader>cR", "<cmd>TypescriptRenameFile<CR>", { desc = "Rename File", buffer = bufnr })
  end

  if client.name ~= "tsserver" and client.name ~= "typescript-tools" then
    -- Enable inlay hints on other languages
    require("lsp-inlayhints").on_attach(client, bufnr)
  end

  if client.name == "pyright" then
    vim.keymap.set("n", "<leader>oi", "<cmd>PyrightOrganizeImports<CR>", { buffer = bufnr, desc = "Organize Imports" })
  end

  -- Disable semantic highlighting temporarily while the colorschemes catch up
  -- https://www.reddit.com/r/neovim/comments/12gvms4/this_is_why_your_higlights_look_different_in_90/
  -- client.server_capabilities.semanticTokensProvider = nil
end

function M.capabilities()
  local cmp_lsp = require "cmp_nvim_lsp"

  local updated_capabilities = vim.lsp.protocol.make_client_capabilities()
  vim.tbl_deep_extend("force", updated_capabilities, cmp_lsp.default_capabilities())

  -- nvim-ufo
  -- updated_capabilities.textDocument.foldingRange = {
  --   dynamicRegistration = false,
  --   lineFoldingOnly = true,
  -- }

  return updated_capabilities
end

function M.filterTypescriptDefinitionFiles(value)
  -- Depending on typescript version either uri or targetUri is returned
  if value.uri then
    return string.match(value.uri, "%.d.ts") == nil
  elseif value.targetUri then
    return string.match(value.targetUri, "%.d.ts") == nil
  end
end

local lsp_diagnostic_enabled = true
function M.toggle_diagnostic_current_buffer()
  -- print(lsp_diagnostic_enabled)

  if lsp_diagnostic_enabled then
    vim.diagnostic.hide(nil, 0)
  else
    vim.diagnostic.show(nil, 0)
  end

  lsp_diagnostic_enabled = not lsp_diagnostic_enabled
end

return M
