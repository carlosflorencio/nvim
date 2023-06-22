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

vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function()
    require("user.util.windows").check_open_tree_in_tab()
  end,
})

vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function()
    -- only run after vim starts
    -- on startup during session loading, TabEnter seems to be called
    -- open tree when creating new tabs
    vim.api.nvim_create_autocmd("TabEnter", {
      group = augroup "tabnew",
      callback = function()
        require("user.util.windows").check_open_tree_in_tab()
      end,
    })
  end,
})

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

--- auto close nvim-tree
-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Auto-Close#rwblokzijl
-- Close the tab if nvim-tree is the last buffer in the tab (after closing a buffer)
-- Close vim if nvim-tree is the last buffer (after closing a buffer)
-- Close nvim-tree across all tabs when one nvim-tree buffer is manually closed if and only if tabs.sync.close is set.
local function tab_win_closed(winnr)
  -- local api = require "nvim-tree.api"
  local tabnr = vim.api.nvim_win_get_tabpage(winnr)
  local bufnr = vim.api.nvim_win_get_buf(winnr)
  local buf_info = vim.fn.getbufinfo(bufnr)[1]
  local tab_wins = vim.tbl_filter(function(w)
    return w ~= winnr
  end, vim.api.nvim_tabpage_list_wins(tabnr))
  local tab_bufs = vim.tbl_map(vim.api.nvim_win_get_buf, tab_wins)
  if buf_info.name:match ".*NvimTree_%d*$" then -- close buffer was nvim tree
    -- Close all nvim tree on :q
    -- if not vim.tbl_isempty(tab_bufs) then -- and was not the last window (not closed automatically by code below)
    -- api.tree.close()
    -- end
  else -- else closed buffer was normal buffer
    if #tab_bufs == 1 then -- if there is only 1 buffer left in the tab
      local last_buf_info = vim.fn.getbufinfo(tab_bufs[1])[1]
      if last_buf_info.name:match ".*NvimTree_%d*$" then -- and that buffer is nvim tree
        vim.schedule(function()
          if #vim.api.nvim_list_wins() == 1 then -- if its the last buffer in vim
            vim.cmd "quit" -- then close all of vim
          else -- else there are more tabs open
            pcall(function()
              vim.api.nvim_win_close(tab_wins[1], true)
            end) -- then close only the tab
          end
        end)
      end
    end
  end
end

vim.api.nvim_create_autocmd("WinClosed", {
  callback = function()
    local winnr = tonumber(vim.fn.expand "<amatch>")
    vim.schedule_wrap(tab_win_closed(winnr))
  end,
  nested = true,
})

-- Custom commands

-- alias :nah for buffer reset changes
vim.cmd [[command Nah edit!]]
