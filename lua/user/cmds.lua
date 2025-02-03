-- Commands to enable/disable autoformat
-- :FormatDisable! to disable autoformat for the current buffer
vim.api.nvim_create_user_command('FormatDisable', function(args)
  local bufnr = vim.api.nvim_get_current_buf()
  if args.bang then
    vim.b[bufnr].disable_autoformat = true
    vim.notify 'Autoformat disabled for the current buffer'
  else
    vim.g.disable_autoformat = true
    vim.notify 'Autoformat disabled globally'
  end
end, {
  desc = 'Disable autoformat-on-save',
  bang = true,
})

vim.api.nvim_create_user_command('SaveAllModifiedBuffers', function()
  for _, buf_id in ipairs(vim.api.nvim_list_bufs()) do
    local filename = vim.api.nvim_buf_get_name(buf_id)
    if filename and filename ~= '' then
      local is_modified = vim.api.nvim_get_option_value('modified', { buf = buf_id })
      if is_modified then
        vim.api.nvim_buf_call(buf_id, function()
          vim.cmd 'write'
        end)
      end
    end
  end

  vim.notify 'All modified buffers have been saved'
end, {
  desc = 'Save all modified buffers where the filename is not empty',
})

vim.api.nvim_create_user_command('FormatEnable', function()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.b[bufnr].disable_autoformat = false
  vim.g.disable_autoformat = false
  vim.notify 'Autoformat enabled (globally + current buffer)'
end, {
  desc = 'Re-enable autoformat-on-save',
})

-- Save buffer
vim.api.nvim_create_user_command('SaveBuffer', function()
  local bufname = vim.api.nvim_buf_get_name(0)

  if string.match(bufname, 'oil://') then
    if vim.bo.modified then
      vim.cmd 'write'
    end
    return
  end

  if bufname == '' then
    -- If the buffer doesn't have a name, ask the user for a file path
    local new_file_path = vim.fn.input {
      prompt = 'Enter file path to save: ',
      default = vim.fn.getcwd(),
      completion = 'dir',
    }
    if new_file_path ~= '' then
      bufname = new_file_path
    else
      print 'Save aborted'
      return
    end
  end

  -- Save the buffer to the determined file path
  if vim.bo.modified then
    vim.cmd('write! ' .. bufname)
  end
end, {
  desc = 'Save Buffer, prompt for file path if not saved yet',
})

vim.api.nvim_create_user_command('QuickFixToggle', function()
  local windows = vim.fn.getwininfo()
  local is_quickfix_open = false

  for _, win in pairs(windows) do
    if win.quickfix == 1 then
      is_quickfix_open = true
      break
    end
  end

  if is_quickfix_open then
    vim.cmd 'cclose'
  else
    -- only open if there are items in the quickfix list
    if not vim.tbl_isempty(vim.fn.getqflist()) then
      vim.cmd 'copen'
      vim.cmd 'wincmd p'
    else
      print 'No items'
    end
  end
end, {
  desc = 'Toggle quickfix',
})

-- Create a new scratch buffer
-- https://naseraleisa.com/posts/diff#clipboard
vim.api.nvim_create_user_command('Ns', function()
  vim.cmd [[
  execute 'vsplit | enew'
  setlocal buftype=nofile
	setlocal bufhidden=hide
  setlocal noswapfile
	]]
end, { nargs = 0 })

-- Compare clipboard to current buffer
vim.api.nvim_create_user_command('DiffWithClipboard', function()
  local ftype = vim.api.nvim_eval '&filetype' -- original filetype
  vim.cmd [[
  tabnew %
  Ns
  normal! P
  windo diffthis
	]]
  vim.cmd('set filetype=' .. ftype)
end, { nargs = 0 })

-- Function to get LSP errors and format them into a string
local function get_lsp_errors()
  -- Get the current buffer number
  local bufnr = vim.api.nvim_get_current_buf()

  -- Get the full file path of the current buffer
  local filepath = vim.api.nvim_buf_get_name(bufnr)

  -- Make the file path relative to the current working directory
  local relative_filepath = vim.fn.fnamemodify(filepath, ':.')

  -- Get diagnostics for the current buffer
  local diagnostics = vim.diagnostic.get(bufnr)

  -- Initialize a table to hold error strings
  local error_messages = {}

  -- Add the relative file path to the beginning of the error messages
  table.insert(error_messages, 'File: ' .. relative_filepath)

  -- Iterate over diagnostics and format them
  for _, diagnostic in ipairs(diagnostics) do
    if diagnostic.severity == vim.diagnostic.severity.ERROR then
      -- Get the line of code where the error occurs
      local error_line = vim.api.nvim_buf_get_lines(bufnr, diagnostic.lnum, diagnostic.lnum + 1, false)[1]

      local message = string.format(
        'Line %d: %s\nCode: %s',
        diagnostic.lnum + 1, -- Convert 0-based line number to 1-based
        diagnostic.message,
        error_line
      )
      table.insert(error_messages, message)
    end
  end

  -- Join all error messages into a single string
  return table.concat(error_messages, '\n')
end

-- Command to print LSP errors
vim.api.nvim_create_user_command('LspErrors', function()
  local errors = get_lsp_errors()
  if errors == '' then
    print 'No LSP errors found.'
  else
    vim.fn.setreg('*', errors)
    print 'LSP errors added to the clipboard.'
  end
end, {})
