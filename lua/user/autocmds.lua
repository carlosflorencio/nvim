-- Disable new line comment
vim.api.nvim_create_autocmd('BufEnter', {
  group = vim.api.nvim_create_augroup('carlos/disable_line_comment', { clear = true }),
  callback = function()
    vim.cmd [[setlocal formatoptions-=o]]
  end,
  desc = 'Disable New Line Comment',
})

-- Auto reload buffer when file changes on disk
-- vim.o.autoread = true (default)
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter' }, {
  group = vim.api.nvim_create_augroup('carlos/autoreload', { clear = true }),
  command = "if mode() != 'c' | checktime | endif",
  pattern = '*',
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.api.nvim_create_augroup('carlos/last_loc', { clear = true }),
  desc = 'Go to the last location when opening a buffer',
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
  group = vim.api.nvim_create_augroup('carlos/qf_always_bottom', { clear = true }),
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

-- Prevent opening splits/windows and having the buffer scrolled to the right
vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinEnter' }, {
  group = vim.api.nvim_create_augroup('carlos/buf_left_align', { clear = true }),
  pattern = '*',
  callback = function()
    -- Ignore terminal buffers
    if vim.bo.buftype == 'terminal' then
      return
    end

    -- Save the current cursor position
    local cursor_pos = vim.api.nvim_win_get_cursor(0)

    -- Move to start of line and adjust view
    vim.cmd 'normal! 0zv'

    -- Restore the original cursor position
    vim.api.nvim_win_set_cursor(0, cursor_pos)
  end,
})

-- Close certain filetypes with <q>
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('carlos/close_with_q', { clear = true }),
  desc = 'Close with <q>',
  pattern = {
    'git',
    'help',
    'qf',
  },
  callback = function(args)
    vim.keymap.set('n', 'q', '<cmd>quit<cr>', { buffer = args.buf })
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
