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
vim.keymap.set({ "n" }, "<F3>", function()
	local path = vim.fn.fnameescape(vim.fn.expand("%:p:."))
	require("spectre").open_visual({ select_word = true, path = path })
end)
vim.keymap.set({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })

-- Paste
vim.keymap.set("v", "<C-p>", "y'>p")

-- fuzzy search current buffer
vim.keymap.set("n", "<c-/>", function()
	-- You can pass additional configuration to telescope to change theme, layout, etc.
	require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 10,
		previewer = false,
	}))
end, { desc = "[/] Fuzzily search in current buffer]" })

-- cycle between buffers
vim.keymap.set("n", "<leader><space>", "<c-^>")

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
vim.keymap.set("n", "]q", ":cnext<cr>")
vim.keymap.set("n", "[q", ":cprev<cr>")

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
vim.keymap.set(
	"n",
	"<leader>cab",
	":%bd|e#|bd#<cr>|'\"<cmd>NvimTreeOpen<cr><c-w><c-l>",
	{ desc = "Close all buffers but the current one" }
)

-- tabs
-- vim.keymap.set("n", "<S-l>", "<cmd>tabn<cr>")
-- vim.keymap.set("n", "<S-h>", "<cmd>tabp<cr>")
vim.keymap.set("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "New Tab" })
vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "Close Tab" })

-- selections
vim.keymap.set("v", "<leader>i", "<esc>`<i", { desc = "Insert at beginning selection" })
vim.keymap.set("v", "<leader>a", "<esc>`>a", { desc = "Insert at end selection" })

vim.keymap.set("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })
