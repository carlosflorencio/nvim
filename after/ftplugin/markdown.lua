-- disable cmp auto completion
-- prevent messing with tab (moving between table cells)
-- require("cmp").setup.buffer {
--   completion = {
--     autocomplete = false,
--   },
-- }

require("cmp").setup.buffer { enabled = false }

-- vim.keymap.set({ "n" }, '<leader>nt', '<c-f>', { buffer = 0, remap = true })
