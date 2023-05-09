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

if vim.g.started_by_firenvim == nil then
  vim.api.nvim_create_autocmd({ "VimEnter" }, {
    callback = function()
      require("nvim-tree.api").tree.toggle {
        focus = false,
      }
    end,
  })
end

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

-- show cursor line only in active window
-- vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
--   callback = function()
--     local ok, cl = pcall(vim.api.nvim_win_get_var, 0, "auto-cursorline")
--     if ok and cl then
--       vim.wo.cursorline = true
--       vim.api.nvim_win_del_var(0, "auto-cursorline")
--     end
--   end,
-- })
-- vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
--   callback = function(args)
--     if vim.bo[args.buf].filetype == "NvimTree" then
--       return
--     end

--     local cl = vim.wo.cursorline
--     if cl then
--       vim.api.nvim_win_set_var(0, "auto-cursorline", cl)
--       vim.wo.cursorline = false
--     end
--   end,
-- })

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
            vim.api.nvim_win_close(tab_wins[1], true) -- then close only the tab
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
