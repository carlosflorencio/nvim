return {
  {
    -- scratch files
    -- Codi! to stop
    -- .mathjs: npm install -g mathjs
    -- .ts: npm install -g tsun
    'metakirby5/codi.vim',
    -- enabled = false,
    lazy = true,
    cmd = { 'Codi', 'CodiNew', 'CodiSelect', 'CodiExpand' },
    init = function()
      vim.g['codi#rightalign'] = 0
      vim.g['codi#autoclose'] = 0
      vim.g['codi#virtual_text'] = 0
    end,
  },

  {
    -- Select a code block and :SnipRun
    -- .ts: npm install -g ts-node typescript
    'michaelb/sniprun',
    lazy = true,
    build = 'sh ./install.sh',
    cmd = { 'SnipRun', 'SnipLive' },
    opts = {
      display = { 'Classic' },
      -- display = { 'TempFloatingWindow' },
      -- display = { 'LongTempFloatingWindow' },
      -- display = { 'VirtualText' },
    },
  },

  {
    'akinsho/toggleterm.nvim',
    version = '*',
    event = 'VeryLazy',
    config = function()
      require('toggleterm').setup {}

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

      vim.keymap.set('n', '<leader>a', function()
        aider:toggle()
      end, { noremap = true, silent = true })

      vim.keymap.set('v', '<leader>a', function()
        local trim_spaces = true
        require('toggleterm').send_lines_to_terminal('visual_lines', trim_spaces, { args = 1 })
      end, { noremap = true, silent = true })

      vim.keymap.set('n', '<leader>A', function()
        local path = vim.fn.expand '%:p'
        aider:send('/add ' .. path)
      end, { noremap = true, silent = true })

      -- vim.keymap.set('n', '<leader>th', '<cmd>ToggleTerm direction=vertical dir=git_dir<cr>', { noremap = true, silent = true })
      -- vim.keymap.set('n', '<leader>tv', '<cmd>ToggleTerm direction=vertical dir=git_dir<cr>', { noremap = true, silent = true })
      -- vim.keymap.set('n', '<leader>T', '<cmd>ToggleTerm direction=tab dir=git_dir<cr>', { noremap = true, silent = true })
    end,
  },
}
