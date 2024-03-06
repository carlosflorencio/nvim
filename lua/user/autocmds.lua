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
-- local highlight_group = vim.api.nvim_create_augroup("YankHighlight", {
--   clear = true,
-- })
-- vim.api.nvim_create_autocmd("TextYankPost", {
--   callback = function()
--     vim.highlight.on_yank()
--   end,
--   group = highlight_group,
--   pattern = "*",
-- })

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

-- Rnsure that changes to buffers are saved when navigating away from the buffer,
-- e.g. by following a link to another file. jakewvincent/mkdnflow.nvim
vim.api.nvim_create_autocmd("FileType", { pattern = "markdown", command = "set awa" })

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

-- lualine recording refresh when entering recording mode
vim.api.nvim_create_autocmd("RecordingEnter", {
  callback = function()
    require("lualine").refresh {
      place = { "statusline" },
    }
  end,
})

vim.api.nvim_create_autocmd("RecordingLeave", {
  callback = function()
    -- This is going to seem really weird!
    -- Instead of just calling refresh we need to wait a moment because of the nature of
    -- `vim.fn.reg_recording`. If we tell lualine to refresh right now it actually will
    -- still show a recording occuring because `vim.fn.reg_recording` hasn't emptied yet.
    -- So what we need to do is wait a tiny amount of time (in this instance 50 ms) to
    -- ensure `vim.fn.reg_recording` is purged before asking lualine to refresh.
    local timer = vim.loop.new_timer()
    timer:start(
      50,
      0,
      vim.schedule_wrap(function()
        require("lualine").refresh {
          place = { "statusline" },
        }
      end)
    )
  end,
})

-- Custom commands
-- alias :nah for buffer reset changes
vim.cmd [[command Nah edit!]]

-- makes * and # work on visual mode too.
vim.api.nvim_exec(
  [[
  function! g:VSetSearch(cmdtype)
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
    let @s = temp
  endfunction

  xnoremap * :<C-u>call g:VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
  xnoremap # :<C-u>call g:VSetSearch('?')<CR>?<C-R>=@/<CR><CR>
]],
  false
)
