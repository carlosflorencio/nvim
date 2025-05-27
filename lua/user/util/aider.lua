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

      vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
      vim.api.nvim_buf_set_keymap(term.bufnr, 'n', '<esc>', '<cmd>close<CR>', { noremap = true, silent = true })
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

  -- toggle aider
  vim.keymap.set('n', '<leader>at', function()
    aider:toggle()
  end, { noremap = true, silent = true })

  -- add file
  vim.keymap.set('n', '<leader>aa', function()
    local path = vim.fn.expand '%:p'
    aider:send('/add ' .. path)
  end, { noremap = true, silent = true })

  -- drop file
  vim.keymap.set('n', '<leader>ad', function()
    local path = vim.fn.expand '%:p'
    aider:send('/drop ' .. path)
  end, { noremap = true, silent = true })

  vim.keymap.set('n', '<leader>ae', function()
    local errors = require('user.util.lsp').get_lsp_errors()

    vim.fn.setreg('*', 'Fix these LSP Errors:\n' .. errors)

    aider:send '/paste'
  end, { noremap = true, silent = true })

  -- visual mode
  vim.keymap.set('v', '<leader>a', function()
    local trim_spaces = true
    require('toggleterm').send_lines_to_terminal('visual_lines', trim_spaces, { args = 1 })
  end, { noremap = true, silent = true })
end

return M
