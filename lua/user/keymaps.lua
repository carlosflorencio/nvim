-- buffer operations
-- if empty, ask for a file path to save
vim.keymap.set('n', '<C-s>', '<cmd>SaveBuffer<CR>', { desc = 'Save buffer' })

-- close buffer without messing with the windows
vim.keymap.set('n', '<C-c>', ':bn|sp|bp|bd<CR>', { desc = 'Close buffer' })

-- new lines
vim.keymap.set('n', '] ', 'o<ESC>k')
vim.keymap.set('n', '[ ', 'O<ESC>j')

-- hightlight current word without moving to the next
vim.keymap.set('n', '*', '*N')

-- Search and replace word under cursor using <F2>
vim.keymap.set('n', '<F2>', ':%s/<C-r><C-w>//<Left>')
vim.keymap.set('v', '<F2>', ':%s/\\%Vs/k/g')
vim.keymap.set({ 'n', 'x' }, 'gw', '*N', { desc = 'Search word under cursor' })

-- iterm2 & alacritty will send custom keycodes for these
vim.keymap.set({ 'n', 'i', 'v' }, '<f13>s', function()
  vim.notify 'F13s'
end)

vim.keymap.set({ 'n', 'i', 'v' }, '<f13>p', function()
  vim.notify 'F13p'
end)

vim.keymap.set({ 'n', 'i', 'v' }, '<s-cr>', function()
  vim.notify '<s-cr>'
end)

-- vim.keymap.set({ 'n', 'i', 'v' }, '<c-cr>', function()
--   vim.notify '<c-cr>'
-- end)

-- moergo crtl+backspace (use c-w instead)
vim.keymap.set({ 'i', 'n' }, '<M-c-bs>', '<nop>')

-- jump between words in insert mode
vim.keymap.set('i', '<M-Right>', '<S-Right>')
vim.keymap.set('i', '<M-Left>', '<S-Left>')
vim.keymap.set('i', '<c-e>', '<c-o>de') -- delete forward word

-- esc
vim.keymap.set({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and Clear highlights' })

-- Paste
vim.keymap.set('v', '<C-p>', "y'>p")

-- cycle between buffers
vim.keymap.set('n', '<leader><space>', '<c-^>', { desc = 'Cycle between buffers' })

-- better window movement
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

vim.keymap.set('n', '<BS>', 'ciw')

-- Resize window using <ctrl> arrow keys
vim.keymap.set('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase window height' })
vim.keymap.set('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease window height' })
vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease window width' })
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase window width' })

-- quickfix
-- make it work like a ring when reaches the end
vim.cmd [[ command! Cnext try | cnext | catch | cfirst | catch | endtry ]]
vim.cmd [[ command! Cprev try | cprev | catch | clast | catch | endtry ]]
vim.keymap.set('n', ']q', ':Cnext<cr>')
vim.keymap.set('n', '[q', ':Cprev<cr>')
vim.keymap.set('n', '<c-q>', ':call QuickFixToggle()<CR>')

-- Move current line / block with Alt-j/k a la vscode.
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==')
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==')
vim.keymap.set('x', '<A-j>', ":m '>+1<CR>gv-gv")
vim.keymap.set('x', '<A-k>', ":m '<-2<CR>gv-gv")

-- better indenting
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- splits
vim.keymap.set('n', '<leader>sv', '<cmd>vsplit<cr>', { desc = 'Split window vertically' })
vim.keymap.set('n', '<leader>sh', '<cmd>split<cr>', { desc = 'Split window horizontally' })
vim.keymap.set('n', '<leader>sc', '<cmd>close<cr>', { desc = 'Close split' })

vim.keymap.set('n', '<leader>st', '<c-w>T', { desc = 'Move split into Tab' })

-- quit buffers / windows
vim.keymap.set('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit all' })
vim.keymap.set('n', '<leader>cw', '<cmd>close<cr>', { desc = 'Close Window' })
vim.keymap.set('n', '<leader>ct', '<cmd>tabclose<cr>', { desc = 'Close Tab' })
-- vim.keymap.set('n', '<leader>cab', ':%bd|e#|bd#<cr>|\'"<cmd>NvimTreeOpen<cr><c-w><c-l>', { desc = 'Close all buffers but the current one' })
vim.keymap.set('n', '<leader>cab', function()
  require('incline').disable()
  vim.cmd [[ %bd|e#|bd# ]]
  vim.cmd [[ NvimTreeOpen ]]
  vim.cmd [[ wincmd l ]]
  require('incline').enable()
end, { desc = 'Close all buffers but the current one' })

-- tabs
vim.keymap.set('n', '<S-l>', '<cmd>tabn<cr>')
vim.keymap.set('n', '<S-h>', '<cmd>tabp<cr>')
vim.keymap.set('n', '<M-S-h>', '<cmd>tabm -1<cr>')
vim.keymap.set('n', '<M-S-l>', '<cmd>tabm +1<cr>')
vim.keymap.set('n', '<leader>tn', '<cmd>tabnew<cr>', { desc = 'New Tab' })
vim.keymap.set('n', '<leader>tc', '<cmd>tabclose<cr>', { desc = 'Close Tab' })

-- selections
vim.keymap.set('v', '<leader>i', '<esc>`<i', { desc = 'Insert at beginning selection' })

vim.keymap.set('n', '<leader>b', '<cmd>enew<cr>', { desc = 'New Buffer' })

-- text wrap
vim.keymap.set('n', '<leader>tw', ':set wrap!<cr>', { desc = 'Toggle line wrap for all splits' })
vim.keymap.set('n', '<leader>tW', ':windo set wrap!<cr>', { desc = 'Toggle line wrap for current buffer' })

-- Surrounds keymaps
vim.keymap.set('n', '<leader>S"', 'ysiW"', { desc = 'Surround word with double quotes', remap = true })
vim.keymap.set('n', '<leader>s"', 'ysiw"', { desc = 'Surround word with double quotes', remap = true })
vim.keymap.set('n', '<leader>s`', 'ysiw`', { desc = 'Surround word with double quotes', remap = true })
vim.keymap.set('n', '<leader>S`', 'ysiW`', { desc = 'Surround word with double quotes', remap = true })

-- visual shorcuts
vim.keymap.set('v', "'", "T'", { desc = 'Surround word with single quotes', remap = true })
vim.keymap.set('v', '"', 'T"', { desc = 'Surround word with double quotes', remap = true })
vim.keymap.set('v', '`', 'T`', { desc = 'Surround word with accent quotes', remap = true })

-- don't yank the replaced text after pasting in visual mode
-- use P
-- vim.keymap.set("x", "p", "P")

-- jump to next special char
-- vim.keymap.set('i', 'jj', "<c-o>:call search('}\\|)\\|]\\|>\\|\"', 'cW')<cr><Right>")
-- vim.keymap.set('i', 'jk', '<ESC>')

-- Don't yank empty lines into the main register
vim.keymap.set('n', 'dd', function()
  if vim.api.nvim_get_current_line():match '^%s*$' then
    return '"_dd'
  else
    return 'dd'
  end
end, { expr = true })

-- rebind 'i' to do a smart-indent if its a blank line
vim.keymap.set('n', 'i', function()
  if #vim.fn.getline '.' == 0 then
    return [["_cc]]
  else
    return 'i'
  end
end, { expr = true })

-- makes * and # work on visual mode too.
vim.cmd [[
  function! g:VSetSearch(cmdtype)
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
    let @s = temp
  endfunction

  xnoremap * :<C-u>call g:VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
  xnoremap # :<C-u>call g:VSetSearch('?')<CR>?<C-R>=@/<CR><CR>
]]

-- Scratch's
vim.keymap.set('n', '<leader>so', function()
  require('user.scratch').search()
end, { desc = 'Open Scratch file' })

vim.keymap.set('n', '<leader>sn', function()
  require('user.scratch').new()
end, { desc = 'New Scratch file (Codi)' })
