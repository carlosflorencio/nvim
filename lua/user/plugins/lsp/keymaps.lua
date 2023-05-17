local M = {}

---@type PluginLspKeys
M._keys = nil

---@return (LazyKeys|{has?:string})[]
function M.get()
  local format = require("user.plugins.lsp.format").format
  local diagnostics_active = true
  if not M._keys then
    ---@class PluginLspKeys
    M._keys = {
      { "<leader>le", vim.diagnostic.open_float, desc = "Line Diagnostics" },
      { "<leader>li", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
      {
        "gd",
        "<cmd>Glance definitions<cr>",
        desc = "Goto Definition",
        has = "definition",
      },
      { "gr", "<cmd>Glance references<cr>", desc = "References" },
      { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
      { "gI", "<cmd>Telescope lsp_implementations<cr>", desc = "Goto Implementation" },
      { "gi", "<cmd>Glance implementations<cr>", desc = "Preview Implementations" },
      { "gt", "<cmd>Glance type_definitions<cr>", desc = "Goto Type Definition" },
      { "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>", desc = "CodeLens Action" },
      { "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<cr>", desc = "Quickfix" },
      { "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
      { "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace Symbols" },
      { "<leader>le", "<cmd>Telescope quickfix<cr>", desc = "Telescope Quickfix" },
      { "<leader>lR", "<cmd>LspRestart<cr>", desc = "Restart LSP" },
      {
        "K",
        function()
          local winid = require("ufo").peekFoldedLinesUnderCursor()
          if not winid then
            vim.lsp.buf.hover()
          end
        end,
        desc = "Hover",
      },
      { "gK", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" },
      {
        "<c-s>",
        vim.lsp.buf.signature_help,
        mode = "i",
        desc = "Signature Help",
        has = "signatureHelp",
      },
      { "]d", M.diagnostic_goto(true), desc = "Next Diagnostic" },
      { "[d", M.diagnostic_goto(false), desc = "Prev Diagnostic" },
      { "]e", M.diagnostic_goto(true, "ERROR"), desc = "Next Error" },
      { "[e", M.diagnostic_goto(false, "ERROR"), desc = "Prev Error" },
      { "]w", M.diagnostic_goto(true, "WARN"), desc = "Next Warning" },
      { "[w", M.diagnostic_goto(false, "WARN"), desc = "Prev Warning" },
      {
        "<leader>la",
        vim.lsp.buf.code_action,
        desc = "Code Action",
        mode = { "n", "v" },
        has = "codeAction",
      },
      { "<leader>fm", format, desc = "Format Document", has = "documentFormatting" },
      {
        "<leader>fm",
        format,
        desc = "Format Range",
        mode = "v",
        has = "documentRangeFormatting",
      },
      {
        "<leader>ld",
        function()
          diagnostics_active = not diagnostics_active
          if diagnostics_active then
            vim.diagnostic.show(nil, 0)
          else
            vim.diagnostic.hide(nil, 0)
          end
        end,
        desc = "Toggle Diagnostics for the current buffer",
      },
    }
    if require("user.util").has "inc-rename.nvim" then
      M._keys[#M._keys + 1] = {
        "<leader>lr",
        function()
          require "inc_rename"
          return ":IncRename " .. vim.fn.expand "<cword>"
        end,
        expr = true,
        desc = "Rename",
        has = "rename",
      }
    else
      M._keys[#M._keys + 1] = { "<leader>lr", vim.lsp.buf.rename, desc = "Rename", has = "rename" }
    end
  end
  return M._keys
end

function M.on_attach(client, buffer)
  local Keys = require "lazy.core.handler.keys"
  local keymaps = {} ---@type table<string,LazyKeys|{has?:string}>

  for _, value in ipairs(M.get()) do
    local keys = Keys.parse(value)
    if keys[2] == vim.NIL or keys[2] == false then
      keymaps[keys.id] = nil
    else
      keymaps[keys.id] = keys
    end
  end

  for _, keys in pairs(keymaps) do
    if not keys.has or client.server_capabilities[keys.has .. "Provider"] then
      local opts = Keys.opts(keys)
      ---@diagnostic disable-next-line: no-unknown
      opts.has = nil
      opts.silent = true
      opts.buffer = buffer
      vim.keymap.set(keys.mode or "n", keys[1], keys[2], opts)
    end
  end
end

function M.diagnostic_goto(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go { severity = severity }
  end
end

return M
