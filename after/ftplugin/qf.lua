-- delete the selected entries after pressing <tab>
vim.keymap.set({ "n" }, 'dd', 'zN', { buffer = 0, remap = true })
-- scroll the preview window
vim.keymap.set({ "n" }, '<c-u>', '<c-b>', { buffer = 0, remap = true })
vim.keymap.set({ "n" }, '<c-d>', '<c-f>', { buffer = 0, remap = true })

