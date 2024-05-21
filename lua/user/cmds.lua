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
