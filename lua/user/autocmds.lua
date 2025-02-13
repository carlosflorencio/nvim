local function augroup(name)
  return vim.api.nvim_create_augroup('user_' .. name, {
    clear = true,
  })
end

vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    vim.cmd [[setlocal formatoptions-=o]]
  end,
  desc = 'Disable New Line Comment',
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd('BufReadPost', {
  group = augroup 'last_loc',
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Disable relative numbers in insert mode
vim.api.nvim_create_autocmd('InsertEnter', {
  pattern = '*',
  callback = function()
    if require('user.util.ai').is_llm_chat_buffer() then
      return
    end

    vim.wo.number = true
    vim.wo.relativenumber = false
  end,
})

-- Enable relative numbers in normal mode
vim.api.nvim_create_autocmd('InsertLeave', {
  pattern = '*',
  callback = function()
    if require('user.util.ai').is_llm_chat_buffer() then
      return
    end
    vim.wo.number = true
    vim.wo.relativenumber = true
  end,
})

-- Delete old marks on startup
vim.api.nvim_create_autocmd({ 'BufRead' }, { command = ':delm a-zA-Z0-9' })

-- always open quickfix at the bottom
vim.api.nvim_create_autocmd('FileType', {
  group = augroup 'qf_always_bottom',
  pattern = 'qf',
  command = 'wincmd J',
})

-- Enable search highlights on certain keys
vim.on_key(function(char)
  if vim.fn.mode() == 'n' then
    local new_hlsearch = vim.tbl_contains({ '<CR>', 'n', 'N', '*', '#', '?', '/' }, vim.fn.keytrans(char))
    if vim.opt.hlsearch:get() ~= new_hlsearch then
      vim.opt.hlsearch = new_hlsearch
    end
  end
end, vim.api.nvim_create_namespace 'auto_hlsearch')

-- Prevent opening splits/windows and having the buffer scroleld to the right
vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinEnter' }, {
  group = augroup 'buf_left_align',
  pattern = '*',
  callback = function()
    -- Save the current cursor position
    local cursor_pos = vim.api.nvim_win_get_cursor(0)

    -- Move to start of line and adjust view
    vim.cmd 'normal! 0zv'

    -- Restore the original cursor position
    vim.api.nvim_win_set_cursor(0, cursor_pos)
  end,
})

-- vim.api.nvim_create_autocmd('User', {
--   pattern = 'OilActionsPost',
--   callback = function(args)
--     dd 'here'
--     -- If err is non-null, we encountered an error while processing the actions
--     if args.data.err then
--       vim.print('ERROR', args.data.err)
--     else
--       vim.print(args)
--     end
--   end,
-- })

-- vim.api.nvim_create_autocmd('User', {
--   pattern = 'OilEnter',
--   callback = function(args)
--     dd 'enter oil'
--   end,
-- })
