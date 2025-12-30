return {
  'NickvanDyke/opencode.nvim',
  dependencies = {
    -- Recommended for better prompt input, and required to use `opencode.nvim`'s embedded terminal — otherwise optional
    -- { 'folke/snacks.nvim', opts = { input = { enabled = true } } },
  },
  config = function()
    -- `opencode.nvim` passes options via a global variable instead of `setup()` for faster startup
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      model = 'github-copilot/gpt-4.1',
    }

    -- Required for `opts.auto_reload`
    vim.opt.autoread = true

    -- Recommended keymaps
    vim.keymap.set('n', '<leader>at', function()
      require('opencode').toggle()
    end, { desc = 'Toggle opencode' })
    vim.keymap.set('n', '<leader>aA', function()
      require('opencode').ask()
    end, { desc = 'Ask opencode' })
    vim.keymap.set('n', '<leader>aa', function()
      require('opencode').ask '@cursor: '
    end, { desc = 'Ask opencode about this' })
    vim.keymap.set('v', '<leader>aa', function()
      require('opencode').ask '@selection: '
    end, { desc = 'Ask opencode about selection' })
    vim.keymap.set('n', '<leader>an', function()
      require('opencode').command 'session_new'
    end, { desc = 'New opencode session' })
    vim.keymap.set('n', '<leader>ay', function()
      require('opencode').command 'messages_copy'
    end, { desc = 'Copy last opencode response' })
    vim.keymap.set({ 'n', 'v' }, '<leader>as', function()
      require('opencode').select()
    end, { desc = 'Select opencode prompt' })

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('carlos/opencode', { clear = true }),
      pattern = { 'opencode_terminal' },
      callback = function(args)
        local bufnr = args.buf
        vim.keymap.set('n', '<c-u>', function()
          require('opencode').command 'messages_half_page_up'
        end, { desc = 'Messages half page up', buffer = bufnr })
        vim.keymap.set('n', '<c-d>', function()
          require('opencode').command 'messages_half_page_down'
        end, { desc = 'Messages half page down', buffer = bufnr })
      end,
    })

    -- Add keymap group if using `which-key.nvim`
    require('which-key').add {
      '<leader>a',
      icon = '󱚣',
      group = 'AI',
      mode = { 'n', 'v' },
    }
  end,
}
