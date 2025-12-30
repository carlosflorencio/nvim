return {
  {
    'zbirenbaum/copilot.lua',
    init = function()
      local node_path, err = require('user.util.env').node_path()
      if err then
        vim.notify('Error getting Node.js path from mise: ' .. err, vim.log.levels.ERROR)
        return
      end
      vim.g.copilot_node_command = node_path .. '/bin/node'
    end,
    cmd = 'Copilot',
    -- Enable Copilot on personal machines (non-work machines)
    enabled = require('user.util.env').is_personal(),
    event = 'InsertEnter',
    opts = {
      copilot_node_command = vim.g.copilot_node_command, -- Set to the path of your Node.js executable
      panel = {
        enabled = true,
        auto_refresh = true,
        keymap = {
          jump_prev = '[[',
          jump_next = ']]',
          accept = '<cr>',
          refresh = '<c-r>',
          open = '<M-CR>',
        },
        layout = {
          position = 'bottom', -- | top | left | right
          ratio = 0.4,
        },
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = false,
          accept_word = false,
          accept_line = false,
          next = false,
          prev = false,
          dismiss = '<M-h>',
        },
      },
      filetypes = {
        yaml = false,
        markdown = true,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ['.'] = false,
      },
      -- copilot_node_command = 'node', -- Node.js version must be > 16.x
      server_opts_overrides = {},
    },
  },
}
