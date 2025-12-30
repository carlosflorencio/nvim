return {
  {
    'augmentcode/augment.vim',
    enabled = function()
      return require('user.util.env').is_work()
    end,
    event = 'VeryLazy',
    init = function()
      local bff_root = vim.fn.expand('~/Sky/bff')
      -- add git worktrees
      local dirs = vim.fn.globpath(bff_root, '*', false, true)
      -- add bff-tools if it exists
      local bff_tools = vim.fn.expand('~/Sky/bff-tools')
      if vim.fn.isdirectory(bff_tools) == 1 then
        table.insert(dirs, bff_tools)
      end
      vim.g.augment_workspace_folders = dirs

      local node_path, err = require("user.util.env").node_path()
      if err then
        vim.notify("Error getting Node.js path from mise: " .. err, vim.log.levels.ERROR)
        return
      end
      vim.g.augment_node_command = node_path .. '/bin/node'
    end,
    keys = {
      {
        '<leader>b',
        function()
          local input = vim.fn.input 'Ask Augment: '
          if input ~= nil and input ~= '' then
            if input:sub(1, 2) == 'c ' then
              -- continue
              vim.cmd('Augment chat ' .. input:sub(3))
            else
              -- always new chat by default
              vim.cmd('Augment chat-new ' .. input)
              vim.cmd('Augment chat ' .. input)
            end
          end
        end,
        desc = 'Augment - Chat Message',
        mode = { 'v', 'n' },
      },
      {
        '<leader>B',
        function()
          vim.cmd('Augment chat-toggle')
        end,
        desc = 'Augment - Toggle chat',
        mode = { 'v', 'n' },
      },
    }

  },
}
