local methods = vim.lsp.protocol.Methods

local function diagnostic_goto(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    pcall(function()
      go { severity = severity }
    end)
  end
end

-- Attach LSP keymaps when a client attaches
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('carlos/user_lsp_attach', { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    if require('user.util.ai').is_llm_chat_buffer() then
      return
    end

    if client ~= nil and client.name == 'typescript-tools' then
      vim.keymap.set('n', '<leader>oa', '<cmd>TSToolsAddMissingImports<CR>',
        { buffer = event.buf, desc = 'Add Missing Imports' })
      vim.keymap.set('n', '<leader>oi', '<cmd>TSToolsOrganizeImports<CR>',
        { buffer = event.buf, desc = 'Organize Imports' })
      vim.keymap.set('n', '<leader>ou', '<cmd>TSToolsRemoveUnusedImports<CR>',
        { buffer = event.buf, desc = 'Remove Unused Imports/Variables' })
    end

    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    map('gd', '<CMD>Glance definitions<CR>', 'Goto Definition')
    map('gD', vim.lsp.buf.declaration, 'Goto Declaration')
    map('gr', '<CMD>Glance references<CR>', 'Goto References')
    map('gI', '<CMD>Glance implementations<CR>', 'Goto Implementation')
    map('gt', '<CMD>Glance type_definitions<CR>', 'Type Definition')
    -- map('<leader>ls', require('telescope.builtin').lsp_document_symbols, 'Document Symbols')
    -- map('<leader>lS', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace Symbols')
    map('<leader>la', vim.lsp.buf.code_action, 'Code Action')
    map('<leader>ld', vim.diagnostic.open_float, 'Code Action')
    map('<leader>le', vim.diagnostic.setqflist, 'All errors in quickfix list')
    map('<leader>li', '<cmd>LspInfo<cr>', 'LspInfo')
    map('K', vim.lsp.buf.hover, 'Hover Documentation')

    -- Signature Help
    map('gK', vim.lsp.buf.signature_help, 'Signature Help')

    if vim.bo.filetype == 'markdown' then
      vim.keymap.set('i', '<c-s>', '<cmd>write<cr>', { buffer = event.buf, desc = 'Save buffer' })
    else
      vim.keymap.set('i', '<c-s>', vim.lsp.buf.signature_help, { buffer = event.buf, desc = 'LSP: Signature Help' })
    end

    map('<leader>lr', vim.lsp.buf.rename, 'Rename')

    -- Jump Diagnostics
    map(']d', diagnostic_goto(true), 'Next Diagnostic')
    map(']D', '<cmd>lua vim.diagnostic.open_float()<cr><cmd>lua vim.diagnostic.open_float()<cr>', 'Open Diagnostic')
    map('[d', diagnostic_goto(false), 'Prev Diagnostic')
    map(']e', diagnostic_goto(true, 'ERROR'), 'Next Error')
    map('[e', diagnostic_goto(false, 'ERROR'), 'Prev Error')
    map(']E', '<cmd>LspErrors<cr>', 'Copy LSP errors to clipboard')
    map(']w', diagnostic_goto(true, 'WARN'), 'Next Warning')
    map('[w', diagnostic_goto(false, 'WARN'), 'Prev Warning')

    -- Toggle Inlay Hints
    if client:supports_method(methods.textDocument_inlayHint) and vim.lsp.inlay_hint then
      map('<leader>lh', function()
        ---@diagnostic disable-next-line: missing-parameter
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end, 'Toggle Inlay Hints')
    end
  end,
})
