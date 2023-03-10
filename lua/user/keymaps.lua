-- Keymaps for better default experience
--vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- buffer operations
vim.keymap.set('n', "<C-s>", ":w<cr>")
vim.keymap.set('n', "<C-c>", ":bn|sp|bp|bd<CR>")

-- Cycle tabs
vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>")
vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>")

-- new lines
vim.keymap.set("n", "zj", "o<ESC>k")
vim.keymap.set("n", "zk", "o<ESC>j")

-- Search and replace word under cursor using <F2>
vim.keymap.set("n", "<F2>", ":%s/<C-r><C-w>//<Left>")
vim.keymap.set({ "n" }, "<F3>", function()
  local path = vim.fn.fnameescape(vim.fn.expand('%:p:.'))
  require('spectre').open_visual({ select_word = true, path = path })
end)

-- Paste
vim.keymap.set("v", "<C-p>", "y'>p")

-- fuzzy search current buffer
vim.keymap.set('n', '<c-/>', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer]' })

-- cycle between buffers
vim.keymap.set("n", "<leader><space>", "<c-^>")

-- better window movement
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")


-- quickfix
vim.keymap.set("n", "]q", ":cnext<cr>")
vim.keymap.set("n", "[q", ":cprev<cr>")

-- Move current line / block with Alt-j/k a la vscode.
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==")
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==")
vim.keymap.set("x", "<A-j>", ":m '>+1<CR>gv-gv")
vim.keymap.set("x", "<A-k>", ":m '<-2<CR>gv-gv")

-- navigate tab completion with <c-j> and <c-k>
vim.keymap.set("i", "<c-j>", "pumvisible() ? \"\\<C-n>\" : \"\\<C-j>\"", { expr = true })
vim.keymap.set("i", "<c-k>", "pumvisible() ? \"\\<C-p>\" : \"\\<C-k>\"", { expr = true })

-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")


