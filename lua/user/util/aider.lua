local M = {}

M.setup = function()
  local Terminal = require('toggleterm.terminal').Terminal

  local aider = Terminal:new {
    cmd = 'pwd;aider',
    dir = 'git_dir',
    -- env = {
    -- AIDER_VIM = 'false',
    -- },
    close_on_exit = false,
    hidden = true,
    direction = 'vertical',
    on_open = function(term)
      vim.cmd 'startinsert!'

      -- adjust width
      local width = math.floor(vim.o.columns * 0.4)
      local winid = vim.api.nvim_get_current_win()
      vim.api.nvim_win_set_width(winid, width)

      vim.keymap.set('n', 'q', '<cmd>close<CR>', { buffer = term.bufnr, noremap = true, silent = true, desc = 'Aider: Close terminal' })
      vim.keymap.set('n', '<esc>', '<cmd>close<CR>', { buffer = term.bufnr, noremap = true, silent = true, desc = 'Aider: Close terminal' })
    end,
  }

  -- run aider for the subtree
  vim.api.nvim_create_user_command('AiderLocalSubtreeOnly', function()
    local curr_buf_dir = vim.fn.expand '%:p:h'

    aider.dir = curr_buf_dir
    aider.cmd = 'pwd;aider --subtree-only'
    aider:toggle()
  end, {
    desc = 'Aider local dir',
  })

  vim.api.nvim_create_user_command('AiderWatch', function()
    aider.cmd = 'pwd;aider --watch-files --model sonnet'
    aider:toggle()
  end, {
    desc = 'Aider watch files',
  })

  vim.keymap.set('n', '<leader>aw', function()
    vim.cmd 'AiderWatch'
  end, { noremap = true, silent = true, desc = 'Aider: Watch Files' })

  vim.keymap.set('n', '<leader>aq', function()
    aider:shutdown()
  end, { noremap = true, silent = true, desc = 'Aider: Terminate' })

  -- toggle aider
  vim.keymap.set('n', '<leader>at', function()
    aider:toggle()
  end, { noremap = true, silent = true, desc = 'Aider: Toggle' })

  -- add file
  vim.keymap.set('n', '<leader>aa', function()
    local path = vim.fn.expand '%:p'
    aider:send('/add ' .. path, true)
  end, { noremap = true, silent = true, desc = 'Aider: Add current file' })

  -- drop file
  vim.keymap.set('n', '<leader>ad', function()
    local path = vim.fn.expand '%:p'
    aider:send('/drop ' .. path, true)
  end, { noremap = true, silent = true, desc = 'Aider: Drop current file' })

  -- LSP Errors
  vim.keymap.set('n', '<leader>ae', function()
    local errors = require('user.util.lsp').get_lsp_errors()

    vim.fn.setreg('*', 'Fix these LSP Errors:\n' .. errors)

    aider:send('/paste', true)
  end, { noremap = true, silent = true, desc = 'Aider: Paste LSP errors' })

  vim.keymap.set('n', '<leader>aE', function()
    local errors = require('user.util.lsp').get_lsp_errors()
    vim.fn.setreg('*', 'Fix these LSP Errors:\n' .. errors)

    local path = vim.fn.expand '%:p'
    aider:send('/add ' .. path)

    aider:send('/paste', true)
  end, { noremap = true, silent = true, desc = 'Aider: Add file and fix lsp errors' })

  -- Reset
  vim.keymap.set('n', '<leader>ar', function()
    aider:send('/reset', true)
  end, { noremap = true, silent = true, desc = 'Aider: Reset' })

  -- visual mode
  vim.keymap.set('v', '<leader>a', function()
    local trim_spaces = true
    require('toggleterm').send_lines_to_terminal('visual_lines', trim_spaces, { args = 1 })
  end, { noremap = true, silent = true, desc = 'Aider: Send visual selection' })
end

return M
