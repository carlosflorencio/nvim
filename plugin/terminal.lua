local set = vim.opt_local

-- Set local settings for terminal buffers
vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
  callback = function()
    set.number = false
    set.relativenumber = false
    set.scrolloff = 0

    local opts = { buffer = 0 }

    -- lazygit esc stops working
    -- vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', '<c-esc>', [[<C-\><C-n>]], opts)
    -- vim.keymap.set('t', 'q', '<cmd>close<cr>', opts)
    vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  end,
})

-- Easily hit escape in terminal mode.
-- Messing with exit esc from fzf-lua
-- vim.keymap.set('t', '<esc><esc>', '<c-\\><c-n>')

-- Open a terminal at the bottom of the screen with a fixed height.
vim.keymap.set('n', '<leader>tv', function()
  vim.cmd.new()
  vim.cmd.wincmd 'L'
  vim.cmd.term()
  vim.cmd.startinsert()
end)

vim.keymap.set('n', '<leader>th', function()
  vim.cmd.new()
  -- vim.cmd.wincmd 'L'
  vim.cmd.term()
  vim.cmd.startinsert()
end)

vim.keymap.set('n', '<leader>T', function()
  vim.cmd.tabnew()
  vim.cmd.term()
  vim.cmd.startinsert()
end)
