-- Keymaps for better default experience
--vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- buffer operations
vim.keymap.set("n", "<C-s>", ":w<cr>", { desc = "Save file" })
-- close buffer without messing with the windows
vim.keymap.set("n", "<C-c>", ":bn|sp|bp|bd<CR>", { desc = "Close buffer" })

-- new lines
vim.keymap.set("n", "zj", "o<ESC>k")
vim.keymap.set("n", "zk", "o<ESC>j")

-- Search and replace word under cursor using <F2>
vim.keymap.set("n", "<F2>", ":%s/<C-r><C-w>//<Left>")
vim.keymap.set("v", "<F2>", ":%s/\\%Vs/k/g")
vim.keymap.set({ "n" }, "<F3>", function()
  local path = vim.fn.fnameescape(vim.fn.expand "%:p:.")
  require("spectre").open_visual { select_word = true, path = path }
end)
vim.keymap.set({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })
-- vim.keymap.set("n", "<esc>", ":noh <CR>", { desc = "Clear highlights" })

-- Paste
vim.keymap.set("v", "<C-p>", "y'>p")

-- fuzzy search current buffer
vim.keymap.set("n", "<c-/>", function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = "[/] Fuzzily search in current buffer]" })

-- cycle between buffers
vim.keymap.set("n", "<leader><space>", "<c-^>", { desc = "Cycle between buffers" })

-- better window movement
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Resize window using <ctrl> arrow keys
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- quickfix
-- make it work like a ring when reaches the end
vim.cmd [[ command! Cnext try | cnext | catch | cfirst | catch | endtry ]]
vim.cmd [[ command! Cprev try | cprev | catch | clast | catch | endtry ]]
vim.keymap.set("n", "]q", ":Cnext<cr>")
vim.keymap.set("n", "[q", ":Cprev<cr>")
vim.keymap.set("n", "<c-q>", ":call QuickFixToggle()<CR>")

-- Move current line / block with Alt-j/k a la vscode.
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==")
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==")
vim.keymap.set("x", "<A-j>", ":m '>+1<CR>gv-gv")
vim.keymap.set("x", "<A-k>", ":m '<-2<CR>gv-gv")

-- navigate tab completion with <c-j> and <c-k>
vim.keymap.set("i", "<c-j>", 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', { expr = true })
vim.keymap.set("i", "<c-k>", 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', { expr = true })

-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- splits
vim.keymap.set("n", "<leader>sv", "<cmd>vsplit<cr>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", "<cmd>split<cr>", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>sc", "<cmd>close<cr>", { desc = "Close split" })

-- quit buffers / windows
vim.keymap.set("n", "<leader>q", "<cmd>qa<cr>", { desc = "Quit all" })
vim.keymap.set("n", "<leader>cw", "<cmd>q<cr>", { desc = "Close Window" })
vim.keymap.set("n", "<leader>ct", "<cmd>tabclose<cr>", { desc = "Close Tab" })
vim.keymap.set(
  "n",
  "<leader>cab",
  ":%bd|e#|bd#<cr>|'\"<cmd>NvimTreeOpen<cr><c-w><c-l>",
  { desc = "Close all buffers but the current one" }
)

-- tabs
vim.keymap.set("n", "<S-l>", "<cmd>tabn<cr>")
vim.keymap.set("n", "<S-h>", "<cmd>tabp<cr>")
vim.keymap.set("n", "<M-S-h>", "<cmd>tabm -1<cr>")
vim.keymap.set("n", "<M-S-l>", "<cmd>tabm +1<cr>")
vim.keymap.set("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "New Tab" })
vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "Close Tab" })

-- selections
vim.keymap.set("v", "<leader>i", "<esc>`<i", { desc = "Insert at beginning selection" })
vim.keymap.set("v", "<leader>a", "<esc>`>a", { desc = "Insert at end selection" })

vim.keymap.set("n", "<leader>b", "<cmd>enew<cr>", { desc = "New Buffer" })

-- debug vars
-- refactoring plugin doesn't work for typescript react atm
-- vim.api.nvim_set_keymap(
--   "n",
--   "<leader>dd",
--   ":lua require('refactoring').debug.print_var({ normal = true })<CR>",
--   { desc = "Debug print var", noremap = true }
-- )
-- vim.api.nvim_set_keymap(
--   "v",
--   "<leader>dd",
--   ":lua require('refactoring').debug.print_var({})<CR>",
--   { desc = "Debug print var", noremap = true }
-- )
-- vim.api.nvim_set_keymap(
--   "n",
--   "<leader>dD",
--   ":lua require('refactoring').debug.cleanup({})<CR>",
--   { desc = "Clear all debug prints", noremap = true }
-- )

vim.keymap.set("n", "<leader>dd", function()
  return require("debugprint").debugprint { variable = true }
end, {
  expr = true,
  desc = "Debug variable print",
})

vim.keymap.set("n", "<leader>dl", function()
  return require("debugprint").debugprint()
end, {
  expr = true,
  desc = "Debug line print",
})

vim.keymap.set("n", "<leader>dD", function()
  require("debugprint").deleteprints()
end, { desc = "Clear all debug prints" })

-- text wrap
vim.keymap.set("n", "<leader>tw", ":set wrap!<cr>", {
  desc = "Toggle line wrap for all splits",
})

vim.keymap.set("n", "<leader>tW", ":windo set wrap!<cr>", {
  desc = "Toggle line wrap for current buffer",
})

-- Surrounds keymaps
vim.keymap.set("n", '<leader>S"', 'ysiW"', {
  desc = "Surround word with double quotes",
  remap = true,
})

vim.keymap.set("n", '<leader>s"', 'ysiw"', {
  desc = "Surround word with double quotes",
  remap = true,
})

vim.keymap.set("n", "<leader>s`", "ysiw`", {
  desc = "Surround word with double quotes",
  remap = true,
})

vim.keymap.set("n", "<leader>S`", "ysiW`", {
  desc = "Surround word with double quotes",
  remap = true,
})
