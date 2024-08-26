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
local linenumbers_ignore_ft = { 'copilot-chat' }
vim.api.nvim_create_autocmd('InsertEnter', {
  pattern = '*',
  callback = function()
    local ft = require('user.util.buffers').get_file_type()
    if vim.tbl_contains(linenumbers_ignore_ft, ft) then
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
    local ft = require('user.util.buffers').get_file_type()
    if vim.tbl_contains(linenumbers_ignore_ft, ft) then
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

-- prevent loading session on stdin args
vim.api.nvim_create_autocmd('StdinReadPre', {
  pattern = '*',
  callback = function()
    vim.g.started_with_stdin = 1
  end,
})

-- nvim tree windows management
-- vim.api.nvim_create_autocmd({ 'VimEnter' }, {
--   callback = function()
--     -- print(vim.inspect(vim.api.nvim_win_get_width(0)))

--     -- open tree on startup, when screen is wide enough
--     if vim.o.columns > 100 then
--       return
--     end

--     vim.schedule_wrap(function()
--       if pcall(require, 'nvim-tree.api') then
--         require('nvim-tree.api').tree.toggle {
--           focus = false,
--         }
--       end
--     end)()

--     -- schedule auto tree close
--     -- needs to be scheduled after openin tree at startup
--     vim.g.auto_tree_cmd_id = vim.api.nvim_create_autocmd('WinEnter', {
--       group = augroup 'buf_enter_tree',
--       callback = function()
--         vim.schedule_wrap(function()
--           require('user.util.windows').close_tree_if_many_windows()
--         end)()
--       end,
--       -- allow this autocmd to run when the cb triggers it again
--       nested = true,
--     })
--   end,
-- })

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
