return {
  {
    'augmentcode/augment.vim',
    enabled = vim.g.is_work,
    event = 'VeryLazy',
    init = function()
      local bff_root = vim.fn.expand('~/Sky/bff')
      -- add git worktrees
      local dirs = vim.fn.globpath(bff_root, '*', false, true)
      table.insert(dirs, '/Users/cfl12/Sky/bff-tools')
      vim.g.augment_workspace_folders = dirs
    end,
    keys = {
      {
        '<leader>b',
        function()
          local input = vim.fn.input 'Ask Augment: '
          if input ~= nil and input ~= '' then
            vim.cmd('Augment chat ' .. input)
          end
        end,
        desc = 'Augment - Chat Message',
        mode = { 'v' },
      },
    }

  },
}
