return {
  {
    'github/copilot.vim',
    enabled = false,
    config = function()
      vim.g.copilot_no_maps = true
      -- issue when expanding a comment inside a docblock
      -- extra * at the beginning of the line are added
    end,
    init = function()
      local function get_mise_node_path()
        local handle = io.popen 'mise where node@latest'
        if not handle then
          return nil, "Failed to execute 'mise where node@latest'"
        end

        local path = handle:read('*a'):match '^%s*(.-)%s*$' -- Read output and trim whitespace
        handle:close()

        if not path or path == '' then
          return nil, 'No path found for node@latest'
        end

        return path, nil
      end

      vim.g.copilot_node_command = get_mise_node_path() .. '/bin/node'
    end,
  },
  {
    'zbirenbaum/copilot.lua',
    enabled = ! vim.g.is_work, -- disable on work laptop
    init = function()
      local function get_mise_node_path()
        local handle = io.popen 'mise where node@latest'
        if not handle then
          return nil, "Failed to execute 'mise where node@latest'"
        end

        local path = handle:read('*a'):match '^%s*(.-)%s*$' -- Read output and trim whitespace
        handle:close()

        if not path or path == '' then
          return nil, 'No path found for node@latest'
        end

        return path, nil
      end

      vim.g.copilot_node_command = get_mise_node_path() .. '/bin/node'
    end,
    cmd = 'Copilot',
    enabled = true,
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
