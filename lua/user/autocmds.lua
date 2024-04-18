local function augroup(name)
  return vim.api.nvim_create_augroup('user_' .. name, {
    clear = true,
  })
end

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

-- highlight yank
vim.cmd[[au TextYankPost * silent! lua vim.highlight.on_yank()]]
vim.cmd [[au InsertEnter * set nu nornu]] -- disable relative numbers in insert mode
vim.cmd [[au InsertLeave * set nu rnu]]


