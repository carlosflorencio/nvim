local function augroup(name)
  return vim.api.nvim_create_augroup("user_" .. name, {
    clear = true,
  })
end

-- vim.api.nvim_create_autocmd("BufEnter", {
--   group = augroup "__env",
--   pattern = ".env",
--   callback = function(args)
--     vim.diagnostic.disable(args.buf)
--   end,
-- })

-- tmp fix for https://github.com/chentoast/marks.nvim/issues/13
vim.api.nvim_create_autocmd({ "BufRead" }, { command = ":delm a-zA-Z0-9" })

-- vim.api.nvim_create_autocmd({ "VimEnter" }, {
--   callback = function()
-- only run after vim starts
-- on startup during session loading, TabEnter seems to be called
-- open tree when creating new tabs
-- vim.api.nvim_create_autocmd("TabEnter", {
--   group = augroup "tabnew",
--   callback = function()
--     require("user.util.windows").close_tree_if_many_windows()
--   end,
-- })
--   end,
-- })

-- vim.api.nvim_create_autocmd("BufWinEnter", {
--   group = augroup "WinEnterCloseTree",
--   callback = function()
--     print "WinEnter"
--     -- require("user.util.windows").close_tree_if_many_windows()
--     -- vim.notify "WinNew"
--   end,
-- })

-- [[ Highlight on yank ]]
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", {
  clear = true,
})
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup "close_with_q",
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query", -- :InspectTree
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup "last_loc",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.cmd [[
  function! QuickFixToggle()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
      copen
    else
      cclose
    endif
  endfunction
]]

-- Rnsure that changes to buffers are saved when navigating away from the buffer,
-- e.g. by following a link to another file. jakewvincent/mkdnflow.nvim
vim.api.nvim_create_autocmd("FileType", { pattern = "markdown", command = "set awa" })

-- nvim tree windows management

-- auto close/open tree when creating new windows
vim.api.nvim_create_autocmd("WinEnter", {
  group = augroup "buf_enter_tree",
  callback = function()
    require("user.util.windows").close_tree_if_many_windows()
  end,
  nested = true,
})

-- close nvim-tree when doing :wq
vim.api.nvim_create_autocmd({ "QuitPre" }, {
  callback = function()
    vim.cmd "NvimTreeClose"
  end,
})

-- Custom commands
-- alias :nah for buffer reset changes
vim.cmd [[command Nah edit!]]
