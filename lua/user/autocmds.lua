local function augroup(name)
  return vim.api.nvim_create_augroup("user_" .. name, {
    clear = true,
  })
end

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
    "chatgpt-input",
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

-- nvim tree windows management
vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function()
    -- open tree on startup
    vim.schedule_wrap(function()
      require("nvim-tree.api").tree.toggle {
        focus = false,
      }
    end)()

    -- schedule auto tree close
    vim.api.nvim_create_autocmd("WinEnter", {
      group = augroup "buf_enter_tree",
      callback = function()
        vim.schedule_wrap(function()
          require("user.util.windows").close_tree_if_many_windows()
        end)()
      end,
      nested = true,
    })
  end,
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
